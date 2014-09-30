#!/usr/bin/perl
$number = 5;
if ( $number > 0) {
 if ( $number > 1) {
  if ( $number > 2) {
   print ("Hello!", "\n");
  while ( $number < 10) {
   print ($number, "\n");
   $number = $number + 1;
  }
}
 while ( $number < 13) {
  print ($number, "\n");
  $number = $number + 2;
 }
}
$number = $number + 100;
print ($number, "\n");
}
