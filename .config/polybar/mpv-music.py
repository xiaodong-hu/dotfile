#!/usr/bin/python
# written by hxd at Dec/04/2017
import subprocess
import os

# shell -> python 管道传入
# percent = float(os.popen("echo '299792' | sudo tlp-stat -b | tail -3 | head -n 1 | tr -d -c '[:digit:],.'").read())
# os.system("mpv --shuffle --no-video ~/Music/CloudMusic > ~/mpv-info.temp")
# title = (os.popen("cat ~/mpv-info.temp | head -n 4 | tail -n -1").read())[36:]
#title = (os.popen("mpv --shuffle --no-video ~/Music/CloudMusic | head -n 4 | tail -n -1").read())[36:]
#print(title)

# run the subprocesses at background
output = subprocess.Popen("mpv --shuffle --no-video ~/Music/CloudMusic > ~/mpv-info.tmp", shell = True)
title = 
# (os.popen("cat ~/mpv-info.tmp | head -n 4 | tail -n -1").read())[36:]
# subprocess.Popen("cat ~/mpv-info.tmp | head -n 4 | tail -n -1", stdout=subprocess.PIPE, shell = True)
# print(title.stdout.read())
print(title)

#title = output.stdout.read()
#title = os.popen("mpv --shuffle --no-video ~/Music/CloudMusic").read()

# Example output
'''
	Playing: /home/hxd/Music/CloudMusic
	[file] This is a directory - adding to playlist.

	Playing: /home/hxd/Music/CloudMusic/やなぎなぎ - 春擬き.mp3
	     Video --vid=1 [P] (mjpeg 640x640)
	 (+) Audio --aid=1 (mp3 2ch 44100Hz)
	File tags:
	 Artist: やなぎなぎ
	 Album: 春擬き
	 Comment: sharing by 暴虐大帝/GUNDAMFO
	 Genre: Anime
	 Title: 春擬き
	 Track: 1
	AO: [pulse] 44100Hz stereo 2ch s16
	A: 00:00:07 / 00:04:30 (2%)
'''
