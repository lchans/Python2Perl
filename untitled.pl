#!/usr/bin/perl

use warnings;
use strict;

`./python2perl.pl change.py > change.pl`;

print "====================== PYTHON ======================\n";
print `cat change.py`;
print "\n";
print "====================== PERL ======================\n";
print `cat change.pl`;
print "\n";

my $out1 = `./change.pl`;
my $out2 = `./change.py`;
print "====================== PYTHON ======================\n";
print $out1;
print "====================== PERL ======================\n";
print $out2;