#!/usr/bin/python
# written by hxd at Dec/27/2017

import os

# require package `sensors`
temperature = os.popen('sensors | grep "Core [0-9]"').read().split("\n")
#print(temperature)
'''
Core 0:        +41.0°C  (high = +84.0°C, crit = +100.0°C)
Core 1:        +39.0°C  (high = +84.0°C, crit = +100.0°C)
Core 2:        +39.0°C  (high = +84.0°C, crit = +100.0°C)
Core 3:        +42.0°C  (high = +84.0°C, crit = +100.0°C)
'''
temp=[]
core_num = 4
for i in range(4):
	temp.append(int(temperature[i][16:18]))

print('Core Average {:.2f}°C'.format(sum(temp)/core_num))
