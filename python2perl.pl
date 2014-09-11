#!/usr/bin/perl

use strict; 
use warnings;

my $file; 
my @words;
my $words;
my $line;
my @line;
my $previous;
my $variable;

foreach $file (<>) { 
	foreach $line ($file) { 
		if ($line =~ /#!/) { 
			print(pythonVersion());
		} elsif ($line =~ /^\s*#/ || $line =~ /^\s*$/) {
			print $line;
		} elsif ($line =~ /print/) { 
			convertPrint($line);
		}
	}
}

sub pythonVersion { 
	return ("#!/usr/bin/perl\n");
}

sub convertPrint { 
	$words = $_[0]; 
	$words .= ', "\n";';
	print($words);
}