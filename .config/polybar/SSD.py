#!/usr/bin/python
import os

ssd_used = os.popen('df -BM | grep /dev/sdb2').read()[24:30]
# '-BM' prints sizes in units of 1,048,576 bytes

ssd_GB = int(ssd_used)/1024

print('SSD {:.2f} GB'.format(ssd_GB))
