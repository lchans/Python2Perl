#!/usr/bin/perl

use strict; 
use warnings;

my $file; 
my @words;
my $words;
my $line;
my @line;
my $name;
my $number;
my $variable;

foreach $file (<>) { 
	@line = split ("\n", $file);
	foreach $line (@line) { 
		if ($line =~ /#!/) { 
			print(pythonVersion());
		} elsif ($line =~ /^\s*#/ || $line =~ /^\s*$/) {
			print $line;
		} elsif ($line =~ /print/) { 
			convertPrint($line);
		} elsif ($line =~ /=/) { 
			convertAssignment ($line);
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

sub convertAssignment { 
	@words = split ("=", $_[0]);
	$name = $words[0];
	$variable = $words[1];
	$words = join ("", "\$", $name, "=", $variable);
	print("$words\n");
}