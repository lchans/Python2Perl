#!/usr/bin/perl
use strict; 
use warnings;

my $file; 
my @words;
my $words;
my $line;
my @line;
my $name;
my $variable;
my $bracket = 0;

foreach $file (<>) { 
	@line = split (/[:\n;]+/, $file);
	foreach $line (@line) { 
		if ($line =~ /#!/) { 
			$line = pythonVersion($line);
		} elsif ($line =~ /^\s*#/ || $line =~ /^\s*$/) {
			$line = "";
		} elsif ($line =~ /print/) { 
			$line = convertPrint($line);
		} elsif ($line =~ /=/ && $line !~ /while/) { 
			$line = convertAssignment ($line);
		} elsif ($line =~ /while/) { 
			$line = convertWhile ($line);
			$bracket= 1;
		} if ($line =~ /\;/ && $bracket == 1) { 
			$line =~ s/;/;\n\}/g;
			$bracket = 0;
		}
		print("$line\n");
	}
}

sub pythonVersion { 
	$words = "#!/usr/bin/perl";
	return $words;
}

sub convertPrint { 
	$words = join ("", "\(", $_[0], ', "\n"', "\);");
	return $words; 
}

sub convertAssignment { 
	@words = split ("[=]", $_[0]);
	$name = $words[0];
	$variable = $words[1];
	if ($variable !~ /[0-9]/) {
		$variable = join ("", "\$", $variable);
	}
	$words = join ("", "\$", $name, "=", $variable, ";");
	return $words;
}

sub convertWhile { 
	@words = split (/while/, $_[0]);
	$name = $words[1];
	$words = join ("", "while \(", $name, "\)", "\{");
	return $words; 
}