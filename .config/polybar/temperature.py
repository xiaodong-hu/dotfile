#!/usr/bin/python
# written by hxd at Dec/27/2017

import os

# require package `sensors`
temperature = os.popen('sensors | head -n 7 | tail -4').read().split("\n")

temp=[]
core_num = 4
for i in range(4):
	temp.append(int(temperature[i][16:18]))

print(' {:.2f}°C'.format(sum(temp)/core_num))