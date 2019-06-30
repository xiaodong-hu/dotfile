#!/usr/bin/python
# written by hxd at JUL/04/2018

import os

omega = os.popen('sudo tlp-stat -t | tail -2 | head -n 1 | tr -d "[a-z][A-Z][(][)][:][ ][\n][/][=]"').read()[1:]
'''
Example output:
	 Fan speed (fan1)       =     0 [/min]
'''
# require `tlp` package installed

print('Fan {} r/min'.format(omega))