#!/usr/bin/python
# written by hxd at Dec/04/2017
'''
import numpy as np

cpu_info = 'cpu MHz'
cpu_freq_data = []

for row in open('/proc/cpuinfo'):
    if row[:6] == cpu_info[:6]:
        # print(row[-9:])
        cpu_freq_data.append(float(row[-9:]))
        # last 8 number is the cpu frequency data

# print(cpu_freq_data)

print('CPU %.2f GHz'%(float(np.mean(cpu_freq_data)/1000)))	# always output with two digits
'''

import os

#frequency = os.popen('cpupower frequency-info | tail -4 | head -n 1 | tr -d "[a-z][A-Z][(][)][:][ ][\n]"').read()
frequency = os.popen('cpupower frequency-info | tail -4 | head -n 1').read()[24:33]
'''
Example output:
	 current CPU frequency: 790 MHz (asserted by call to kernel)
'''
# require `cpupower` package installed

print('CPU{}'.format(frequency))
