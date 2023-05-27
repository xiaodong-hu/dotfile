#!/usr/bin/python
# written by hxd at Dec/04/2017
import os

'''
############### CPU Frequency ##############
'''
frequency = os.popen('cpupower frequency-info | tail -4 | head -n 1').read()[24:33] # require `cpupower` package installed
'''
Example output:
	 current CPU frequency: 790 MHz (asserted by call to kernel)
'''

'''
############### CPU Temperature ##############
'''
temperature_string_list = os.popen('sensors | grep "Core [0-9]"').read().split("\n") # require package `sensors`
'''
Example output:
    Core 0:        +33.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 4:        +36.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 8:        +40.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 9:        +40.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 10:       +40.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 11:       +40.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 12:       +37.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 13:       +37.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 14:       +37.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 15:       +37.0°C  (high = +100.0°C, crit = +100.0°C)
'''
temperature_list: list[int] = []
physical_core_num = int(os.popen('lscpu | head -12 | tail -1').read()[-5:])
'''
Example output:
    Cores(s) per socket:            10
'''
for i in range(physical_core_num):
	temperature_list.append(int(temperature_string_list[i][16:18]))


################ Output #################
print('Core{}'.format(frequency), '{:.2f}°C'.format(sum(temperature_list)/physical_core_num))
