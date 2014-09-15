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
my $variable;
my $bracket = 0;
my $count = 0;
my $tab = 0;
my $currentTab = $tab;

foreach $file (<>) { 
	@line = split (/[;:\n]+/, $file);
	foreach $line (@line) { 

		$line =~ /^(\s*)/;
		$count = length( $1 );
		
		if ($line =~ /#!/) { 
			$line = pythonVersion($line);
		} elsif ($line =~ /print/) { 
			$line = convertPrint($line);
			$line .= ";";
		} elsif ($line =~ /=/ && $line !~ /while/) { 
			$line = convertAssignment ($line);
			$line .= ";";
		} elsif ($line =~ /while/) { 
			$line = convertWhile ($line);
			$count = $count + 1;
			$currentTab = $count;
		} if ($currentTab > $count) { 
			$currentTab = $count;
			print("}");
		}
		print("$line\n");
	}
}

 if ($currentTab == $count) { 
	print("\}\n");
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
	return $letter;
}


sub convertWhile { 
	$section = convertAssignment($_[0]);
	@words = split ("while", $section);
	$name = $words[1];
	$words = join ("", "while \(", $name, "\)", "\{");
	return $words; 
}