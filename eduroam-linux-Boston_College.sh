#!/usr/bin/env bash
if [ -z "$BASH" ] ; then
   bash  $0
   exit
fi



my_name=$0


function setup_environment {
  bf=""
  n=""
  ORGANISATION="Boston College"
  URL="https://www.bc.edu/help"
  SUPPORT="help.center@bc.edu"
if [ ! -z "$DISPLAY" ] ; then
  if which zenity 1>/dev/null 2>&1 ; then
    ZENITY=`which zenity`
  elif which kdialog 1>/dev/null 2>&1 ; then
    KDIALOG=`which kdialog`
  else
    if tty > /dev/null 2>&1 ; then
      if  echo $TERM | grep -E -q "xterm|gnome-terminal|lxterminal"  ; then
        bf="[1m";
        n="[0m";
      fi
    else
      find_xterm
      if [ -n "$XT" ] ; then
        $XT -e $my_name
      fi
    fi
  fi
fi
}

function split_line {
echo $1 | awk  -F '\\\\n' 'END {  for(i=1; i <= NF; i++) print $i }'
}

function find_xterm {
terms="xterm aterm wterm lxterminal rxvt gnome-terminal konsole"
for t in $terms
do
  if which $t > /dev/null 2>&1 ; then
  XT=$t
  break
  fi
done
}


function ask {
     T="eduroam CAT"
#  if ! [ -z "$3" ] ; then
#     T="$T: $3"
#  fi
  if [ ! -z $KDIALOG ] ; then
     if $KDIALOG --yesno "${1}\n${2}?" --title "$T" ; then
       return 0
     else
       return 1
     fi
  fi
  if [ ! -z $ZENITY ] ; then
     text=`echo "${1}" | fmt -w60`
     if $ZENITY --no-wrap --question --text="${text}\n${2}?" --title="$T" 2>/dev/null ; then
       return 0
     else
       return 1
     fi
  fi

  yes=Y
  no=N
  yes1=`echo $yes | awk '{ print toupper($0) }'`
  no1=`echo $no | awk '{ print toupper($0) }'`

  if [ $3 == "0" ]; then
    def=$yes
  else
    def=$no
  fi

  echo "";
  while true
  do
  split_line "$1"
  read -p "${bf}$2 ${yes}/${no}? [${def}]:$n " answer
  if [ -z "$answer" ] ; then
    answer=${def}
  fi
  answer=`echo $answer | awk '{ print toupper($0) }'`
  case "$answer" in
    ${yes1})
       return 0
       ;;
    ${no1})
       return 1
       ;;
  esac
  done
}

function alert {
  if [ ! -z $KDIALOG ] ; then
     $KDIALOG --sorry "${1}"
     return
  fi
  if [ ! -z $ZENITY ] ; then
     $ZENITY --warning --text="$1" 2>/dev/null
     return
  fi
  echo "$1"

}

function show_info {
  if [ ! -z $KDIALOG ] ; then
     $KDIALOG --msgbox "${1}"
     return
  fi
  if [ ! -z $ZENITY ] ; then
     $ZENITY --info --width=500 --text="$1" 2>/dev/null
     return
  fi
  split_line "$1"
}

function confirm_exit {
  if [ ! -z $KDIALOG ] ; then
     if $KDIALOG --yesno "Really quit?"  ; then
     exit 1
     fi
  fi
  if [ ! -z $ZENITY ] ; then
     if $ZENITY --question --text="Really quit?" 2>/dev/null ; then
        exit 1
     fi
  fi
}



function prompt_nonempty_string {
  prompt=$2
  if [ ! -z $ZENITY ] ; then
    if [ $1 -eq 0 ] ; then
     H="--hide-text "
    fi
    if ! [ -z "$3" ] ; then
     D="--entry-text=$3"
    fi
  elif [ ! -z $KDIALOG ] ; then
    if [ $1 -eq 0 ] ; then
     H="--password"
    else
     H="--inputbox"
    fi
  fi


  out_s="";
  if [ ! -z $ZENITY ] ; then
    while [ ! "$out_s" ] ; do
      out_s=`$ZENITY --entry --width=300 $H $D --text "$prompt" 2>/dev/null`
      if [ $? -ne 0 ] ; then
        confirm_exit
      fi
    done
  elif [ ! -z $KDIALOG ] ; then
    while [ ! "$out_s" ] ; do
      out_s=`$KDIALOG $H "$prompt" "$3"`
      if [ $? -ne 0 ] ; then
        confirm_exit
      fi
    done  
  else
    while [ ! "$out_s" ] ; do
      read -p "${prompt}: " out_s
    done
  fi
  echo "$out_s";
}

function user_cred {
  PASSWORD="a"
  PASSWORD1="b"

  if ! USER_NAME=`prompt_nonempty_string 1 "enter your userid"` ; then
    exit 1
  fi

  while [ "$PASSWORD" != "$PASSWORD1" ]
  do
    if ! PASSWORD=`prompt_nonempty_string 0 "enter your password"` ; then
      exit 1
    fi
    if ! PASSWORD1=`prompt_nonempty_string 0 "repeat your password"` ; then
      exit 1
    fi
    if [ "$PASSWORD" != "$PASSWORD1" ] ; then
      alert "passwords do not match"
    fi
  done
}
setup_environment
show_info "This installer has been prepared for ${ORGANISATION}\n\nMore information and comments:\n\nEMAIL: ${SUPPORT}\nWWW: ${URL}\n\nInstaller created with software from the GEANT project."
if ! ask "This installer will only work properly if you are a member of ${bf}Boston College.${n}" "Continue" 1 ; then exit; fi
if ! ask "Boston College Acceptable Use Policy\n\nThe BC network is primarily for the use of members of the BC community to foster BC's mission.  Network access for guests of the University is provided as a courtesy, and should not be used to disrupt the BC network in any way.  If you choose to use the BC network below, you are subject to the policy found at www.bc.edu/techpolicy . You should be aware that (a) BC has the right to monitor your use of the network with automated systems that detect misuse of the BC network (e.g. spreading viruses, "hacking," copyright violations, or personally abusive behavior), and (b) your network access may be revoked at any time in the event that misuse is detected.\n${n}" "Continue" 1 ; then exit; fi
if [ -d $HOME/.cat_installer ] ; then
   if ! ask "Directory $HOME/.cat_installer exists; some of its files may be overwritten." "Continue" 1 ; then exit; fi
else
  mkdir $HOME/.cat_installer
fi
# save certificates
echo "-----BEGIN CERTIFICATE-----
MIIENjCCAx6gAwIBAgIBATANBgkqhkiG9w0BAQUFADBvMQswCQYDVQQGEwJTRTEU
MBIGA1UEChMLQWRkVHJ1c3QgQUIxJjAkBgNVBAsTHUFkZFRydXN0IEV4dGVybmFs
IFRUUCBOZXR3b3JrMSIwIAYDVQQDExlBZGRUcnVzdCBFeHRlcm5hbCBDQSBSb290
MB4XDTAwMDUzMDEwNDgzOFoXDTIwMDUzMDEwNDgzOFowbzELMAkGA1UEBhMCU0Ux
FDASBgNVBAoTC0FkZFRydXN0IEFCMSYwJAYDVQQLEx1BZGRUcnVzdCBFeHRlcm5h
bCBUVFAgTmV0d29yazEiMCAGA1UEAxMZQWRkVHJ1c3QgRXh0ZXJuYWwgQ0EgUm9v
dDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALf3GjPm8gAELTngTlvt
H7xsD821+iO2zt6bETOXpClMfZOfvUq8k+0DGuOPz+VtUFrWlymUWoCwSXrbLpX9
uMq/NzgtHj6RQa1wVsfwTz/oMp50ysiQVOnGXw94nZpAPA6sYapeFI+eh6FqUNzX
mk6vBbOmcZSccbNQYArHE504B4YCqOmoaSYYkKtMsE8jqzpPhNjfzp/haW+710LX
a0Tkx63ubUFfclpxCDezeWWkWaCUN/cALw3CknLa0Dhy2xSoRcRdKn23tNbE7qzN
E0S3ySvdQwAl+mG5aWpYIxG3pzOPVnVZ9c0p10a3CitlttNCbxWyuHv77+ldU9U0
WicCAwEAAaOB3DCB2TAdBgNVHQ4EFgQUrb2YejS0Jvf6xCZU7wO94CTLVBowCwYD
VR0PBAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wgZkGA1UdIwSBkTCBjoAUrb2YejS0
Jvf6xCZU7wO94CTLVBqhc6RxMG8xCzAJBgNVBAYTAlNFMRQwEgYDVQQKEwtBZGRU
cnVzdCBBQjEmMCQGA1UECxMdQWRkVHJ1c3QgRXh0ZXJuYWwgVFRQIE5ldHdvcmsx
IjAgBgNVBAMTGUFkZFRydXN0IEV4dGVybmFsIENBIFJvb3SCAQEwDQYJKoZIhvcN
AQEFBQADggEBALCb4IUlwtYj4g+WBpKdQZic2YR5gdkeWxQHIzZlj7DYd7usQWxH
YINRsPkyPef89iYTx4AWpb9a/IfPeHmJIZriTAcKhjW88t5RxNKWt9x+Tu5w/Rw5
6wwCURQtjr0W4MHfRnXnJK3s9EK0hZNwEGe6nQY1ShjTK3rMUUKhemPR5ruhxSvC
Nr4TDea9Y355e6cJDUCrat2PisP29owaQgVR1EX1n6diIWgVIEM8med8vSTYqZEX
c4g/VhsxOBi0cQ+azcgOno4uG+GMmIPLHzHxREzGBHNJdmAPx/i9F4BrLunMTA5a
mnkPIAou1Z5jJh5VkpTYghdae9C8x49OhgQ=
-----END CERTIFICATE-----

-----BEGIN CERTIFICATE-----
MIIF2DCCA8CgAwIBAgIQTKr5yttjb+Af907YWwOGnTANBgkqhkiG9w0BAQwFADCB
hTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
A1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxKzApBgNV
BAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTAwMTE5
MDAwMDAwWhcNMzgwMTE4MjM1OTU5WjCBhTELMAkGA1UEBhMCR0IxGzAZBgNVBAgT
EkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMR
Q09NT0RPIENBIExpbWl0ZWQxKzApBgNVBAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNh
dGlvbiBBdXRob3JpdHkwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCR
6FSS0gpWsawNJN3Fz0RndJkrN6N9I3AAcbxT38T6KhKPS38QVr2fcHK3YX/JSw8X
pz3jsARh7v8Rl8f0hj4K+j5c+ZPmNHrZFGvnnLOFoIJ6dq9xkNfs/Q36nGz637CC
9BR++b7Epi9Pf5l/tfxnQ3K9DADWietrLNPtj5gcFKt+5eNu/Nio5JIk2kNrYrhV
/erBvGy2i/MOjZrkm2xpmfh4SDBF1a3hDTxFYPwyllEnvGfDyi62a+pGx8cgoLEf
Zd5ICLqkTqnyg0Y3hOvozIFIQ2dOciqbXL1MGyiKXCJ7tKuY2e7gUYPDCUZObT6Z
+pUX2nwzV0E8jVHtC7ZcryxjGt9XyD+86V3Em69FmeKjWiS0uqlWPc9vqv9JWL7w
qP/0uK3pN/u6uPQLOvnoQ0IeidiEyxPx2bvhiWC4jChWrBQdnArncevPDt09qZah
SL0896+1DSJMwBGB7FY79tOi4lu3sgQiUpWAk2nojkxl8ZEDLXB0AuqLZxUpaVIC
u9ffUGpVRr+goyhhf3DQw6KqLCGqR84onAZFdr+CGCe01a60y1Dma/RMhnEw6abf
Fobg2P9A3fvQQoh/ozM6LlweQRGBY84YcWsr7KaKtzFcOmpH4MN5WdYgGq/yapiq
crxXStJLnbsQ/LBMQeXtHT1eKJ2czL+zUdqnR+WEUwIDAQABo0IwQDAdBgNVHQ4E
FgQUu69+Aj36pvE8hI6t7jiY7NkyMtQwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB
/wQFMAMBAf8wDQYJKoZIhvcNAQEMBQADggIBAArx1UaEt65Ru2yyTUEUAJNMnMvl
wFTPoCWOAvn9sKIN9SCYPBMtrFaisNZ+EZLpLrqeLppysb0ZRGxhNaKatBYSaVqM
4dc+pBroLwP0rmEdEBsqpIt6xf4FpuHA1sj+nq6PK7o9mfjYcwlYRm6mnPTXJ9OV
2jeDchzTc+CiR5kDOF3VSXkAKRzH7JsgHAckaVd4sjn8OoSgtZx8jb8uk2Intzna
FxiuvTwJaP+EmzzV1gsD41eeFPfR60/IvYcjt7ZJQ3mFXLrrkguhxuhoqEwWsRqZ
CuhTLJK7oQkYdQxlqHvLI7cawiiFwxv/0Cti76R7CZGYZ4wUAc1oBmpjIXUDgIiK
boHGhfKppC3n9KUkEEeDys30jXlYsQab5xoq2Z0B15R97QNKyvDb6KkBPvVWmcke
jkk9u+UJueBPSZI9FoJAzMxZxuY67RIuaTxslbH9qh17f4a+Hg4yRvv7E491f0yL
S0Zj/gA0QHDBw7mh3aZw4gSzQbzpgJHqZJx64SIDqZxubw5lT2yHh17zbqD5daWb
QOhTsiedSrnAdyGN/4fy3ryM7xfft0kL0fJuMAsaDk527RH89elWsn2/x20Kk4yl
0MC2Hb46TpSi125sC8KKfPog88Tk5c0NqMuRkrF8hey1FGlmDoLnzc7ILaZRfyHB
NVOFBkpdn627G190
-----END CERTIFICATE-----

-----BEGIN CERTIFICATE-----
MIIFdDCCBFygAwIBAgIQJ2buVutJ846r13Ci/ITeIjANBgkqhkiG9w0BAQwFADBv
MQswCQYDVQQGEwJTRTEUMBIGA1UEChMLQWRkVHJ1c3QgQUIxJjAkBgNVBAsTHUFk
ZFRydXN0IEV4dGVybmFsIFRUUCBOZXR3b3JrMSIwIAYDVQQDExlBZGRUcnVzdCBF
eHRlcm5hbCBDQSBSb290MB4XDTAwMDUzMDEwNDgzOFoXDTIwMDUzMDEwNDgzOFow
gYUxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAO
BgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYD
VQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MIICIjANBgkq
hkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAkehUktIKVrGsDSTdxc9EZ3SZKzejfSNw
AHG8U9/E+ioSj0t/EFa9n3Byt2F/yUsPF6c947AEYe7/EZfH9IY+Cvo+XPmT5jR6
2RRr55yzhaCCenavcZDX7P0N+pxs+t+wgvQUfvm+xKYvT3+Zf7X8Z0NyvQwA1onr
ayzT7Y+YHBSrfuXjbvzYqOSSJNpDa2K4Vf3qwbxstovzDo2a5JtsaZn4eEgwRdWt
4Q08RWD8MpZRJ7xnw8outmvqRsfHIKCxH2XeSAi6pE6p8oNGN4Tr6MyBSENnTnIq
m1y9TBsoilwie7SrmNnu4FGDwwlGTm0+mfqVF9p8M1dBPI1R7Qu2XK8sYxrfV8g/
vOldxJuvRZnio1oktLqpVj3Pb6r/SVi+8Kj/9Lit6Tf7urj0Czr56ENCHonYhMsT
8dm74YlguIwoVqwUHZwK53Hrzw7dPamWoUi9PPevtQ0iTMARgexWO/bTouJbt7IE
IlKVgJNp6I5MZfGRAy1wdALqi2cVKWlSArvX31BqVUa/oKMoYX9w0MOiqiwhqkfO
KJwGRXa/ghgntNWutMtQ5mv0TIZxMOmm3xaG4Nj/QN370EKIf6MzOi5cHkERgWPO
GHFrK+ymircxXDpqR+DDeVnWIBqv8mqYqnK8V0rSS527EPywTEHl7R09XiidnMy/
s1Hap0flhFMCAwEAAaOB9DCB8TAfBgNVHSMEGDAWgBStvZh6NLQm9/rEJlTvA73g
JMtUGjAdBgNVHQ4EFgQUu69+Aj36pvE8hI6t7jiY7NkyMtQwDgYDVR0PAQH/BAQD
AgGGMA8GA1UdEwEB/wQFMAMBAf8wEQYDVR0gBAowCDAGBgRVHSAAMEQGA1UdHwQ9
MDswOaA3oDWGM2h0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9BZGRUcnVzdEV4dGVy
bmFsQ0FSb290LmNybDA1BggrBgEFBQcBAQQpMCcwJQYIKwYBBQUHMAGGGWh0dHA6
Ly9vY3NwLnVzZXJ0cnVzdC5jb20wDQYJKoZIhvcNAQEMBQADggEBAGS/g/FfmoXQ
zbihKVcN6Fr30ek+8nYEbvFScLsePP9NDXRqzIGCJdPDoCpdTPW6i6FtxFQJdcfj
Jw5dhHk3QBN39bSsHNA7qxcS1u80GH4r6XnTq1dFDK8o+tDb5VCViLvfhVdpfZLY
Uspzgb8c8+a4bmYRBbMelC1/kZWSWfFMzqORcUx8Rww7Cxn2obFshj5cqsQugsv5
B5a6SE2Q8pTIqXOi6wZ7I53eovNNVZ96YUWYGGjHXkBrI/V5eu+MtWuLt29G9Hvx
PUsE2JOAWVrgQSQdso8VYFhH2+9uRv0V9dlfmrPb2LjkQLPNlzmuhbsdjrzch5vR
pu/xO28QOG8=
-----END CERTIFICATE-----

-----BEGIN CERTIFICATE-----
MIIGDjCCA/agAwIBAgIQNoJef7WkgZN+9tFza7k8pjANBgkqhkiG9w0BAQwFADCB
hTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
A1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxKzApBgNV
BAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTQwMjEy
MDAwMDAwWhcNMjkwMjExMjM1OTU5WjCBljELMAkGA1UEBhMCR0IxGzAZBgNVBAgT
EkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMR
Q09NT0RPIENBIExpbWl0ZWQxPDA6BgNVBAMTM0NPTU9ETyBSU0EgT3JnYW5pemF0
aW9uIFZhbGlkYXRpb24gU2VjdXJlIFNlcnZlciBDQTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBALkU2YXyQURX/zBEHtw8RKMXuG4B+KNfwqkhHc5Z9Ozz
iKkJMjyxi2OkPic284/5OGYuB5dBj0um3cNfnnM858ogDU98MgXPwS5IZUqF0B9W
MW2O5cYy1Bu8n32W/JjXT/j0WFb440W+kRiC5Iq+r81SN1GHTx6Xweg6rvn/RuRl
Pz/DR4MvzLhCXi1+91porl1LwKY1IfWGo8hJi5hjYA3JIUjCkjBlRrKGNQRCJX6t
p05LEkAAeohoXG+fo6R4ESGuPQsOvkUUI8/rddf2oPG8RWxevKEy7PNYeEIoCzoB
dvDFoJ7BaXDej0umed/ydrbjDxN8GDuxUWxqIDnOnmkCAwEAAaOCAWUwggFhMB8G
A1UdIwQYMBaAFLuvfgI9+qbxPISOre44mOzZMjLUMB0GA1UdDgQWBBSa8yvaz61P
ti+7KkhIKhK3G0LBJDAOBgNVHQ8BAf8EBAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIB
ADAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwGwYDVR0gBBQwEjAGBgRV
HSAAMAgGBmeBDAECAjBMBgNVHR8ERTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9k
b2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9uQXV0aG9yaXR5LmNybDBxBggr
BgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29tb2RvY2EuY29t
L0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAGmKNmiaHjtlC+B8z6ar
cTuvYaQ/5GQBSRDTHY/i1e1n055bl71CHgf50Ltt9zKVWiIpYvgMnFlWJzagIhIR
+kf0UclZeylKpUg1fMWXZuAnJTsVejJ1SpH7pmue4lP6DYwT+yO4CxIsru3bHUeQ
1dCTaXaROBU01xjqfrxrWN4qOZADRARKVtho5fV8aX6efVRL0NiGq2dmE1deiSoX
rS2uvUAOZu2K/1S0wQHLqeBHuhFhj62uI0gqxiV5iRxBBJXAEepXK9a0l/qx6RVi
7Epxd/3zoZza9msAKcUy5/pO6rMqpxiXHFinQjZf7BTP+HsO993MiBWamlzI8SDH
0YZyoRebrrr+bKgy0QB2SXP3PyeHPLbJLfqqkJDJCgmfyWkfBxmpv966+AuIgkQW
EH8HwIAiX3+8MN66zQd5ZFbY//NPnDC7bh5RS+bNvRfExb/IP46xH4pGtwZDb2It
z1GdRcqK6ROLwMeRvlu2+jdKif7wndoTJiIsBpA+ixOYoBnW3dpKSH89D4mdJHJL
DntE/9Q2toN2I1iLFGy4XfdhbTl27d0SPWuHiJeRvsBGAh52HN22r1xP9QDWnE2p
4J6ijvyxFnlcIdNFgZoMOWxtKNcl0rcRkND23m9e9Pqki2Z3ci+bkEAsUhJg+f+1
cC6JmnkJiYEt7Fx4b4GH8fxV
-----END CERTIFICATE-----

" > $HOME/.cat_installer/ca.pem
function run_python_script {
PASSWORD=$( echo "$PASSWORD" | sed "s/'/\\\'/g" )
if python << EEE1 > /dev/null 2>&1
import dbus
EEE1
then
    PYTHON=python
elif python3 << EEE2 > /dev/null 2>&1
import dbus
EEE2
then
    PYTHON=python3
else
    PYTHON=none
    return 1
fi

$PYTHON << EOF > /dev/null 2>&1
#-*- coding: utf-8 -*-
import dbus
import re
import sys
import uuid
import os

class EduroamNMConfigTool:

    def connect_to_NM(self):
        #connect to DBus
        try:
            self.bus = dbus.SystemBus()
        except dbus.exceptions.DBusException:
            print("Can't connect to DBus")
            sys.exit(2)
        #main service name
        self.system_service_name = "org.freedesktop.NetworkManager"
        #check NM version
        self.check_nm_version()
        if self.nm_version == "0.9" or self.nm_version == "1.0":
            self.settings_service_name = self.system_service_name
            self.connection_interface_name = "org.freedesktop.NetworkManager.Settings.Connection"
            #settings proxy
            sysproxy = self.bus.get_object(self.settings_service_name, "/org/freedesktop/NetworkManager/Settings")
            #settings intrface
            self.settings = dbus.Interface(sysproxy, "org.freedesktop.NetworkManager.Settings")
        elif self.nm_version == "0.8":
            #self.settings_service_name = "org.freedesktop.NetworkManagerUserSettings"
            self.settings_service_name = "org.freedesktop.NetworkManager"
            self.connection_interface_name = "org.freedesktop.NetworkManagerSettings.Connection"
            #settings proxy
            sysproxy = self.bus.get_object(self.settings_service_name, "/org/freedesktop/NetworkManagerSettings")
            #settings intrface
            self.settings = dbus.Interface(sysproxy, "org.freedesktop.NetworkManagerSettings")
        else:
            print("This Network Manager version is not supported")
            sys.exit(2)

    def check_opts(self):
        self.cacert_file = '${HOME}/.cat_installer/ca.pem'
        self.pfx_file = '${HOME}/.cat_installer/user.p12'
        if not os.path.isfile(self.cacert_file):
            print("Certificate file not found, looks like a CAT error")
            sys.exit(2)

    def check_nm_version(self):
        try:
            proxy = self.bus.get_object(self.system_service_name, "/org/freedesktop/NetworkManager")
            props = dbus.Interface(proxy, "org.freedesktop.DBus.Properties")
            version = props.Get("org.freedesktop.NetworkManager", "Version")
        except dbus.exceptions.DBusException:
            version = "0.8"
        if re.match(r'^1\.', version):
            self.nm_version = "1.0"
            return
        if re.match(r'^0\.9', version):
            self.nm_version = "0.9"
            return
        if re.match(r'^0\.8', version):
            self.nm_version = "0.8"
            return
        else:
            self.nm_version = "Unknown version"
            return

    def byte_to_string(self, barray):
        return "".join([chr(x) for x in barray])


    def delete_existing_connections(self, ssid):
        "checks and deletes earlier connections"
        try:
            conns = self.settings.ListConnections()
        except dbus.exceptions.DBusException:
            print("DBus connection problem, a sudo might help")
            exit(3)
        for each in conns:
            con_proxy = self.bus.get_object(self.system_service_name, each)
            connection = dbus.Interface(con_proxy, "org.freedesktop.NetworkManager.Settings.Connection")
            try:
               connection_settings = connection.GetSettings()
               if connection_settings['connection']['type'] == '802-11-wireless':
                   conn_ssid = self.byte_to_string(connection_settings['802-11-wireless']['ssid'])
                   if conn_ssid == ssid:
                       connection.Delete()
            except dbus.exceptions.DBusException:
               pass

    def add_connection(self,ssid):
        server_alt_subject_name_list = dbus.Array({'DNS:helix.bc.edu'})
        server_name = 'helix.bc.edu'
        if self.nm_version == "0.9" or self.nm_version == "1.0":
             match_key = 'altsubject-matches'
             match_value = server_alt_subject_name_list
        else:
             match_key = 'subject-match'
             match_value = server_name
            
        s_con = dbus.Dictionary({
            'type': '802-11-wireless',
            'uuid': str(uuid.uuid4()),
            'permissions': ['user:$USER'],
            'id': ssid 
        })
        s_wifi = dbus.Dictionary({
            'ssid': dbus.ByteArray(ssid.encode('utf8')),
            'security': '802-11-wireless-security'
        })
        s_wsec = dbus.Dictionary({
            'key-mgmt': 'wpa-eap',
            'proto': ['rsn',],
            'pairwise': ['ccmp',],
            'group': ['ccmp', 'tkip']
        })
        s_8021x = dbus.Dictionary({
            'eap': ['peap'],
            'identity': '$USER_NAME',
            'ca-cert': dbus.ByteArray("file://{0}\0".format(self.cacert_file).encode('utf8')),
             match_key: match_value,
            'password': '$PASSWORD',
            'phase2-auth': 'mschapv2',
        })
        s_ip4 = dbus.Dictionary({'method': 'auto'})
        s_ip6 = dbus.Dictionary({'method': 'auto'})
        con = dbus.Dictionary({
            'connection': s_con,
            '802-11-wireless': s_wifi,
            '802-11-wireless-security': s_wsec,
            '802-1x': s_8021x,
            'ipv4': s_ip4,
            'ipv6': s_ip6
        })
        self.settings.AddConnection(con)

    def main(self):
        self.check_opts()
        ver = self.connect_to_NM()
        self.delete_existing_connections('eduroam')
        self.add_connection('eduroam')
        self.delete_existing_connections('BostonCollege')

if __name__ == "__main__":
    ENMCT = EduroamNMConfigTool()
    ENMCT.main()
EOF
}
function create_wpa_conf {
cat << EOFW >> $HOME/.cat_installer/cat_installer.conf

network={
  ssid="eduroam"
  key_mgmt=WPA-EAP
  pairwise=CCMP
  group=CCMP TKIP
  eap=PEAP
  ca_cert="${HOME}/.cat_installer/ca.pem"
  identity="${USER_NAME}"
  domain_suffix_match="helix.bc.edu"
  phase2="auth=MSCHAPV2"
  password="${PASSWORD}"
}
EOFW
chmod 600 $HOME/.cat_installer/cat_installer.conf
}
#prompt user for credentials
  user_cred
  if run_python_script ; then
   show_info "Installation successful"
else
   show_info "Network Manager configuration failed, generating wpa_supplicant.conf"
   if ! ask "Network Manager configuration failed, but we may generate a wpa_supplicant configuration file if you wish. Be warned that your connection password will be saved in this file as clear text." "Write the file" 1 ; then exit ; fi

if [ -f $HOME/.cat_installer/cat_installer.conf ] ; then
  if ! ask "File $HOME/.cat_installer/cat_installer.conf exists; it will be overwritten." "Continue" 1 ; then confirm_exit; fi
  rm $HOME/.cat_installer/cat_installer.conf
  fi
   create_wpa_conf
   show_info "Output written to $HOME/.cat_installer/cat_installer.conf"
fi
