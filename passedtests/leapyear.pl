#!/usr/bin/perl
# Python code snippet;
# Written by Lavender Chan;
# Prints out whether this current year is a leap year;
 $year = 2014;
print ( $year, "\n");
if (  $year % 4 == 0) {
 if (  $year % 400 == 0) {
  print ( '...is a leap $year!', "\n");
 }
 elsif ( $year % 100 == 0) {
  print ( '...is not a leap $year!', "\n");
 }
 else {
  print ( '...is a leap $year!', "\n");
 }
}
else {
 print ( '...is not a leap $year!', "\n");
}
