#!/usr/bin/python
# written by hxd at Dec/04/2017

import os

# shell -> python 管道传入
percent = float(os.popen("echo '299792' | sudo tlp-stat -b | tail -3 | head -n 1 | tr -d -c '[:digit:],.'").read())

if percent > 90:
	print(' %.1f'%percent+'%')
elif percent < 90 and percent > 65:
	print(' %.1f'%percent+'%')
elif percent < 65 and percent > 40:
	print(' %.1f'%percent+'%')
elif percent < 40 and percent > 15:
	print(' %.1f'%percent+'%')
elif percent < 15:
	print(' %.1f'%percent+'%')
