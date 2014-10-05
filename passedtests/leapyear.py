#!/usr/bin/python
# Python code snippet
# Written by Lavender Chan
# Prints out whether this current year is a leap year

year = 2014
print year

if year % 4 == 0: 
	if year % 400 == 0: 
		print '...is a leap year!'
	elif year % 100 == 0: 
		print '...is not a leap year!'
	else: 
		print '...is a leap year!'
else: 
	print '...is not a leap year!'