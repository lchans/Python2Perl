#!/usr/bin/perl
# Python code snippet;
# Written by Lavender Chan;
# Nested statements ;
 $number = 10;
while ($number < 100) {
 if (  $number < 30) {
  if (  $number % 3 == 0) {
    $number = $number - 1;
  }
  else {
    $number = $number + 4;
  }
}
 elsif ( $number < 40) {
  while ($number < 35) {
    $number = $number + 5;
  }
}
 elsif ( $number < 70) {
  if (  $number > 60) {
    $number = $number + 1;
  }
}
  $number = $number + 10;
 print ( $number, "\n");
}
