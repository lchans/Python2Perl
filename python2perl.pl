#!/usr/bin/perl
use strict; 
use warnings;

my $file; 
my @words;
my @section;
my $section;
my $words;
my $line;
my @line;
my $name;
my $count = 0;
my $currentTab = 0;

my @bracket;
my $bracketCounter = 0;

foreach $file (<>) { 
	@line = split (/[;:\n]+/, $file);
	foreach $line (@line) { 

		$count = countTabs($line);
		printIndentation($currentTab);

		if ($line =~ /#!/) { 
			$line = pythonVersion($line);
		} elsif ($line =~ /print/) { 
			$line = convertPrint($line);
			$line .= ";";
		} elsif ($line =~ /=/ && $line !~ /while/ && $line !~ /if/) { 
			$line = convertAssignment ($line);
			$line .= ";";
		} elsif ($line =~ /while/) { 
			$line = convertWhile ($line);
			$currentTab = $count;
			$bracketCounter++;
		} elsif ($line =~ /if/) { 
			$line = convertIf ($line);
			$currentTab = $count;
			$bracketCounter++;
			push (@bracket, "\{");
		} if ($currentTab > $count) { 
			$currentTab = $count;
			$bracketCounter--;
			print("\}");
			pop (@bracket);
		}
		print("$line\n");
	}
}

while ($#bracket + 1 > 0) { 
	pop (@bracket);
	print ("\}");
}


sub pythonVersion { 
	$words = "#!/usr/bin/perl";
	return $words;
}

sub convertPrint { 
	$section = $_[0];
	$section =~ s/print//g;
	$section = convertAssignment($section);
	$words = join ("", "print ", "\(", $section, ', "\n"', "\)");
	return $words; 
}

sub convertAssignment { 
	my $letter; 
	@section = split (" ", $_[0]);
	foreach $section (@section) { 
		if ($section =~ /[a-z]+/) { 
			$section = join("", "\$",$section);
		} 
		$letter .= " ";
		$letter .= $section;
	}
	$letter =~ s/(^\s*)//;
	return $letter;
}

sub countTabs { 
	$_[0] =~ /^(\s*)/;
	$count = length( $1 );
	return $count;
}

sub printIndentation { 
	for (my $i = 0; $i < $_[0]; $i++) { 
		print ("    ");
	}
}


sub convertWhile { 
	$section = convertAssignment($_[0]);
	@words = split ("while", $section);
	$name = $words[1];
	$words = join ("", "while \(", $name, "\)", "\{");
	return $words; 
}

sub convertIf { 
	$section = convertAssignment($_[0]);
	@words = split ("if", $section);
	$name = $words[1];
	$words = join ("", "if \(", $name, "\)", "\{");
	return $words; 
}