#!/usr/bin/env bash

set -uo pipefail

readonly main_output="eDP-1"
readonly -a main_workspaces=(
  one two three four five six seven eight nine ten
)
readonly -a external_workspaces=(
  eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty
)

external_output=""
last_external_output="__initial__"
state_file=""

get_external_output() {
  local outputs

  outputs="$(niri msg -j outputs 2>/dev/null)" || return 1
  jq -r --arg main "$main_output" \
    'keys | map(select(. != $main)) | first // empty' <<<"$outputs"
}

workspace_index() {
  local name="$1"
  local i

  for i in "${!main_workspaces[@]}"; do
    if [[ "${main_workspaces[$i]}" == "$name" || "${external_workspaces[$i]}" == "$name" ]]; then
      printf '%s\n' "$i"
      return 0
    fi
  done

  return 1
}

write_state() {
  local state="$1"
  local temporary

  temporary="$(mktemp "${state_file}.XXXXXX")" || return 1
  printf '%s\n' "$state" >"$temporary"
  mv -f "$temporary" "$state_file"
}

read_state() {
  if [[ -r "$state_file" ]] && jq -e 'type == "array"' "$state_file" >/dev/null 2>&1; then
    jq -c . "$state_file"
  else
    printf '[]\n'
  fi
}

collapse_external_workspaces() {
  local workspaces windows focused_name state ws_id id i target
  local -a move_ids=()
  local -a move_targets=()

  workspaces="$(niri msg -j workspaces 2>/dev/null)" || return
  windows="$(niri msg -j windows 2>/dev/null)" || return
  focused_name="$(jq -r '.[] | select(.is_focused) | .name // empty' <<<"$workspaces")"
  state="$(read_state)"

  for i in "${!external_workspaces[@]}"; do
    ws_id="$(
      jq -r --arg name "${external_workspaces[$i]}" \
        '[.[] | select(.name == $name) | .id] | first // empty' <<<"$workspaces"
    )"
    [[ -n "$ws_id" ]] || continue

    while IFS= read -r id; do
      [[ -n "$id" ]] || continue
      state="$(
        jq -c --argjson id "$id" --arg workspace "${external_workspaces[$i]}" \
          '[.[] | select(.window_id != $id)] + [{window_id: $id, workspace: $workspace}]' \
          <<<"$state"
      )"
      move_ids+=("$id")
      move_targets+=("${main_workspaces[$i]}")
    done < <(jq -r --argjson ws_id "$ws_id" '.[] | select(.workspace_id == $ws_id) | .id' <<<"$windows")
  done

  # Save first so an interrupted migration can still be recovered.
  write_state "$state" || return

  for i in "${!move_ids[@]}"; do
    niri msg action move-window-to-workspace \
      --window-id "${move_ids[$i]}" --focus false "${move_targets[$i]}" >/dev/null 2>&1 || true
  done

  # If unplugging left focus on an external workspace, follow its windows home.
  if i="$(workspace_index "$focused_name")" && [[ "$focused_name" == "${external_workspaces[$i]}" ]]; then
    niri msg action focus-workspace "${main_workspaces[$i]}" >/dev/null 2>&1 || true
  fi
}

restore_external_workspaces() {
  local output="$1"
  local topology_changed="$2"
  local workspaces windows focused_name state remaining
  local ws_output id original current_ws_id current_name expected_main i

  workspaces="$(niri msg -j workspaces 2>/dev/null)" || return
  focused_name="$(jq -r '.[] | select(.is_focused) | .name // empty' <<<"$workspaces")"

  # Keep the external half of every pair on the selected external monitor.
  for i in "${!external_workspaces[@]}"; do
    ws_output="$(
      jq -r --arg name "${external_workspaces[$i]}" \
        '[.[] | select(.name == $name) | .output] | first // empty' <<<"$workspaces"
    )"
    if [[ -n "$ws_output" && "$ws_output" != "$output" ]]; then
      niri msg action move-workspace-to-monitor \
        --reference "${external_workspaces[$i]}" "$output" >/dev/null 2>&1 || true
    fi
  done

  workspaces="$(niri msg -j workspaces 2>/dev/null)" || return
  windows="$(niri msg -j windows 2>/dev/null)" || return
  state="$(read_state)"
  remaining='[]'

  while IFS=$'\t' read -r id original; do
    [[ -n "$id" && -n "$original" ]] || continue
    i="$(workspace_index "$original")" || continue
    expected_main="${main_workspaces[$i]}"
    current_ws_id="$(jq -r --argjson id "$id" '[.[] | select(.id == $id) | .workspace_id] | first // empty' <<<"$windows")"

    # Closed windows and windows deliberately moved elsewhere while mobile are
    # intentionally forgotten rather than being pulled back unexpectedly.
    [[ -n "$current_ws_id" ]] || continue
    current_name="$(jq -r --argjson id "$current_ws_id" '[.[] | select(.id == $id) | .name] | first // empty' <<<"$workspaces")"
    [[ "$current_name" == "$expected_main" ]] || continue

    if ! niri msg action move-window-to-workspace \
      --window-id "$id" --focus false "$original" >/dev/null 2>&1; then
      remaining="$(
        jq -c --argjson id "$id" --arg workspace "$original" \
          '. + [{window_id: $id, workspace: $workspace}]' <<<"$remaining"
      )"
    fi
  done < <(jq -r '.[] | [.window_id, .workspace] | @tsv' <<<"$state")

  write_state "$remaining" || return

  # On a fresh connection, show the pair matching the current laptop workspace
  # and leave keyboard focus on the laptop display.
  if [[ "$topology_changed" == true ]] && i="$(workspace_index "$focused_name")" \
    && [[ "$focused_name" == "${main_workspaces[$i]}" ]]; then
    niri msg action focus-workspace "${external_workspaces[$i]}" >/dev/null 2>&1 || true
    niri msg action focus-workspace "${main_workspaces[$i]}" >/dev/null 2>&1 || true
  fi
}

sync_workspace_topology() {
  local topology_changed=false

  external_output="$(get_external_output)" || return
  if [[ "$external_output" != "$last_external_output" ]]; then
    topology_changed=true
  fi

  if [[ -z "$external_output" ]]; then
    collapse_external_workspaces
  else
    restore_external_workspaces "$external_output" "$topology_changed"
  fi

  last_external_output="$external_output"
}

watch_workspace_topology() {
  local runtime_dir socket_id event

  command -v jq >/dev/null 2>&1 || exit 1
  command -v flock >/dev/null 2>&1 || exit 1
  runtime_dir="${XDG_RUNTIME_DIR:?XDG_RUNTIME_DIR is not set}"
  socket_id="${NIRI_SOCKET##*/}"
  state_file="${runtime_dir}/niri-paired-workspaces-${socket_id}.json"
  umask 077

  # A config reload or accidental second launch must not create two watchers.
  exec 9>"${state_file%.json}.lock"
  flock -n 9 || exit 0

  sync_workspace_topology

  # Output hotplug always changes niri's workspace set. The initial snapshot is
  # also a WorkspacesChanged event, making startup reconciliation deterministic.
  while IFS= read -r event; do
    if [[ "$event" == *'"WorkspacesChanged"'* ]]; then
      sync_workspace_topology
    fi
  done < <(niri msg -j event-stream 2>/dev/null)
}

switch_workspace_pair() {
  local num="$1"
  local index main_ws ext_ws output

  case "$num" in
    [1-9]) index=$((num - 1)) ;;
    0) index=9 ;;
    *) return 1 ;;
  esac

  main_ws="${main_workspaces[$index]}"
  ext_ws="${external_workspaces[$index]}"
  output="$(get_external_output)" || return 1

  # The workspace declarations normally enforce this; the action also repairs
  # placement after unusual output transitions.
  niri msg action move-workspace-to-monitor \
    --reference "$main_ws" "$main_output" >/dev/null 2>&1 || true

  if [[ -n "$output" ]]; then
    niri msg action move-workspace-to-monitor \
      --reference "$ext_ws" "$output" >/dev/null 2>&1 || true
    niri msg action focus-workspace "$ext_ws" >/dev/null 2>&1 || true
  fi

  # This is deliberately unconditional: without an external monitor, Mod+n
  # must still switch among the ten laptop workspaces.
  niri msg action focus-workspace "$main_ws" >/dev/null 2>&1 || true
}

case "${1:-}" in
  --watch) watch_workspace_topology ;;
  *) switch_workspace_pair "${1:-}" ;;
esac
