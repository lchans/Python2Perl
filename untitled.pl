#!/usr/bin/perl

use warnings;
use strict;

`./python2perl.pl change.py > change.pl`;
`./python2perl.pl test1.py > test1.pl`;

print "====================== PYTHON ======================\n";
print `cat change.py`;
print "\n";
print "====================== PERL ======================\n";
print `cat change.pl`;
print "\n";

my $out1 = `./change.py`;
my $out2 = `./change.pl`;
print "====================== PYTHON ======================\n";
print $out1;
print "====================== PERL ======================\n";
print $out2;
