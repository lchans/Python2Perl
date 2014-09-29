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
	$count = countTabs($line);
	@line = split (/[;:\n]+/, $file);
	foreach $line (@line) { 
		if ($line =~ /^\s*$/) {
		} else { 

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
				push (@bracket, "\{");
			} elsif ($line =~ /elif/) { 
				if (defined $count && defined $currentTab 
				&& $count <= $currentTab && $#bracket + 1 > 0) { 
					$currentTab = $count;
					print("\}");
					pop (@bracket);
				}
				$line = convertElif ($line);
				$currentTab = $count;
				push (@bracket, "\{");
			} elsif ($line =~ /^if.+/) { 
				if (defined $count && defined $currentTab 
				&& $count <= $currentTab && $#bracket + 1 > 0) { 
					$currentTab = $count;
					print("\}");
					pop (@bracket);
				}
				$line = convertIf ($line);
				$currentTab = $count;
				push (@bracket, "\{");
			} elsif ($line =~ /else/) { 
				pop (@bracket);
				print("\}");
				$line = convertElse ($line);
				$currentTab = $count;
				push (@bracket, "\{");
			} 

			print("$line\n");
		}
	}

	if ($count == $currentTab && $#bracket + 1 > 0) {
		print("\}\n");
		pop (@bracket);
	}
}

while ($#bracket + 1 > 0) { 
	$count--;
	printIndentation($count);
	pop (@bracket);
	print ("\}\n");
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
	my $inQuote = 0;
	@section = split (" ", $_[0]);
	foreach $section (@section) { 
		if ($section =~ /[a-z]+/) { 
			if ($section =~ /\"/) {
				if ($inQuote == 0) {
					$inQuote = 1; 
				} else { 
					$inQuote = 0;
				}
			} if ($inQuote == 0) {
				$section = join("", "\$",$section);
			}
		} 
		$letter .= " ";
		$letter .= $section;
	}
	$letter =~ s/(^\s*)//;
	return $letter;
}

sub countTabs { 
	if (defined $_[0]) {
	$_[0] =~ /^(\s+)/;
	$count = length( $1 );
	return $count;
	}
	return 0;
}

sub printIndentation { 
	if(defined $_[0]){
		for (my $i = 0; $i < $_[0]; $i++) { 
			print ("    ");
		}
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

sub convertElif { 
	$section = convertAssignment($_[0]);
	@words = split ("elif", $section);
	$name = $words[1];
	$words = join ("", "elsif \(", $name, "\)", "\{");
	return $words; 
}

sub convertElse { 
	$words = "else \{";
	return $words; 
}