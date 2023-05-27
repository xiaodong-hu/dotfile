#!/usr/bin/python
# written by hxd at Dec/04/2017

import os

# shell -> python 管道传入
# change the /etc/sudoers to run /usr/bin/tlp-stat without password
# Example Output of tlp-stat:
'''
	--- TLP 1.1 --------------------------------------------

	+++ ThinkPad Battery Features
	tp-smapi   = inactive (unsupported hardware)
	tpacpi-bat = active

	+++ ThinkPad Battery Status: BAT0 (Main / Internal)
	/sys/class/power_supply/BAT0/manufacturer                   = SMP
	/sys/class/power_supply/BAT0/model_name                     = 01AV431
	/sys/class/power_supply/BAT0/cycle_count                    =      3
	/sys/class/power_supply/BAT0/energy_full_design             =  57020 [mWh]
	/sys/class/power_supply/BAT0/energy_full                    =  58500 [mWh]
	/sys/class/power_supply/BAT0/energy_now                     =  29340 [mWh]
	/sys/class/power_supply/BAT0/power_now                      =   7941 [mW]
	/sys/class/power_supply/BAT0/status                         = Discharging

	tpacpi-bat.BAT0.startThreshold                              =     40 [%]
	tpacpi-bat.BAT0.stopThreshold                               =     80 [%]
	tpacpi-bat.BAT0.forceDischarge                              =      0

	Charge                                                      =   50.2 [%]
	Capacity                                                    =  102.6 [%]
''' 
Instantaneous_Power = int(os.popen("sudo tlp-stat -b | tail -10 | head -n 1").read()[-13:-6])
Energy_Now = int(os.popen("sudo tlp-stat -b | tail -11 | head -n 1").read()[-13:-6])
print('{:.2f} W | {:.2f} Wh'.format(Instantaneous_Power/1000,Energy_Now/1000))



'''
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
'''
