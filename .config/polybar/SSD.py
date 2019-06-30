#!/usr/bin/python
import os

ssd_used = (os.popen('df -BM | grep /dev/nvme0n1p3').read()[22:26]
# '-BM' prints sizes in units of 1,048,576 bytes
# '-h' prints size in GB

print(ssd_used)
#ssd_GB = int(ssd_used)/1024

#print('SSD {:.2f} GB'.format(ssd_GB))
