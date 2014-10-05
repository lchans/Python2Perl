#!/usr/bin/perl
# Python code snippet;
# Written by Lavender Chan;
# Prints the 20th fibonacci number;
 $left = 0;
 $right = 1;
 $current = $left + $right;
 $counter = 0;
while ($counter < 20) {
  $current = $left + $right;
  $left = $right;
  $right = $current;
  $counter = $counter + 1;
}
print ( $left, "\n");
