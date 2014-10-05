#!/usr/bin/perl
# Python code snippet;
# Written by Lavender Chan;
# Lots of arithmetic operations ;
 $current = 100;
print ( $current, "\n");
while ($current > 1) {
 if (  $current % 2 == 0) {
   $current = $current / 2;
 }
 else {
   $current = $current * 3 + 1;
 }
 print ( $current, "\n");
}
