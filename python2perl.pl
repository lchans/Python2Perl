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
my @strings;

foreach $file (<>) { 

	@line = split (/[\n]+/, $file);
	foreach $line (@line) { 
			$count = countTabs($line);

			if ($count <= $currentTab && $#bracket + 1 > 0) {
				while ($currentTab + 4 > $count) {
					printIndentation($currentTab);
					print("\}\n");
					pop (@bracket);
					$currentTab = $currentTab - 4;
				}

			}
			printIndentation($count);
			if ($line =~ /(if|elsif|while).*(;|:)/) {
			@strings = split (/[;:]+/, $line);
			} else { 
			@strings = $line;
			}
			
			foreach $line (@strings) {
			if ($line =~ /^\s*$/ || $line =~ /import/) {
			} else { 

				if ($line =~ /#!/) { 
					$line = pythonVersion($line);
				} elsif ($line =~ /print/) { 
					$line = convertPrint($line);
					$line .= ";";
				}  elsif ($line =~ /sys.stdin.readline/) { 
					$line = convertRead ($line);
					$line .= ";";
				}elsif ($line =~ /=/ && $line !~ /while/ && $line !~ /if/) { 
					$line = convertAssignment ($line);
					$line .= ";";
				} elsif ($line =~ /while/) { 
					$line = convertWhile ($line);
					$currentTab = $count;
					push (@bracket, "\{");
				} elsif ($line =~ /elif/) { 
					if (defined $count && defined $currentTab 
					&& $count < $currentTab && $#bracket + 1 > 0) { 
						print("\}");
						pop (@bracket);
					}
					$line = convertElif ($line);
					$currentTab = $count;
					push (@bracket, "\{");
				} elsif ($line =~ /if/) { 
					if (defined $count && defined $currentTab 
					&& $count < $currentTab && $#bracket + 1 > 0) { 
						$currentTab = $count;
						print("\}");
						pop (@bracket);
					}
					$line = convertIf ($line);
					$currentTab = $count;
					push (@bracket, "\{");
				} elsif ($line =~ /else/) { 
					$line = convertElse ($line);
					push (@bracket, "\{");
					$currentTab = $count;
				} elsif ($line =~ /for/) { 
					$line = convertFor ($line);
					push (@bracket, "\{");
					$currentTab = $count;
				} elsif ($line =~ /sys.stdout.write/) {
					$line = convertWrite ($line);
					$line .= ";";
				} elsif ($line =~ /^\s*break\s*$/) { 
					$line = convertBreak($line);
					$line .= ";";
				}
				print("$line\n");
			}
		}
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
	$section =~ s/\"/\'/g;
	
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
	if (defined $count) {
	return $count;
	} else { 
		return 0;
	}
	}
	return 0;
}

sub printIndentation { 
	if(defined $_[0]){
		for (my $i = 0; $i < $_[0]; $i++) { 
			print (" ");
		}
	}
}

sub convertWhile { 
	$section = convertAssignment($_[0]);
	@words = split ("while", $section);
	$name = $words[1];
	$words = "while \($name\) \{";
	return $words; 
}

sub convertIf { 
	$section = convertAssignment($_[0]);
	@words = split ("if", $section);
	$name = $words[1];
	$words = "if \($name\) \{";
	return $words; 
}

sub convertElif { 
	$section = convertAssignment($_[0]);
	@words = split ("elif", $section);
	$name = $words[1];
	$words = "elsif \($name\) \{";
	return $words; 
}

sub convertFor { 
	$section = convertAssignment($_[0]);
	$section =~ s/\(/ /g;
	$section =~ s/\)/ /g;
	$section =~ s/\,//g;
	@words = split (" ", $section);
	$words = "foreach $words[1] \($words[4]\.\.$words[5]\) \{";
	return $words;
}

sub convertWrite {
	$section = convertAssignment($_[0]);
	@words = split ("\"", $section);
	$words = "print \"$words[1]\"";
	return $words;
}	

sub convertRead { 
	$section = convertAssignment($_[0]);
	@words = split (" ", $section);
	$words = "$words[0] $words[1] \<STDIN\>";
	return $words;
}

sub convertBreak { 
	return "last";
}

sub convertElse { 
	$words = "else \{";
	return $words; 
}