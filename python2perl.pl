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

my $arraySection; 
my @array;

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
				} elsif ($line =~ /.+\=.*\[.+\]/) { 
					$line = convertArray($line);
					$line .= ";"
				} elsif ($line =~ /print/) { 
					$line = convertPrint($line);
					$line .= ";";
				}  elsif ($line =~ /sys.stdin.readline/) { 
					$line = convertRead ($line);
					$line .= ";";
				}elsif ($line =~ /=/ && $line !~ /(\s+|^)while\s+/ && $line !~ /(\s+|^)if\s+/) { 
					$line = convertAssignment ($line);
					$line .= ";";
				} elsif ($line =~ /(\s+|^)while\s+/) { 
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
				} elsif ($line =~ /(\s+|^)if\s+/) { 
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
	if ($section =~ /print$/) {
		$words = 'print "\n"';
	} else {
		$section =~ s/print//g;
		$section = convertAssignment($section);
		$section =~ s/\"/\'/g;
		$words = join ("", "print ", "\(", $section, ', "\n"', "\)");
	}
	return $words; 
}

sub convertAssignment { 
	my $letter; 
	my $inQuote = 0;
	@section = split (" ", $_[0]);
	foreach $section (@section) { 
		if ($section =~ /[a-z]+/) {  
				if ($section =~ /\"/ || $section =~ /\'/) {
					$inQuote = !$inQuote;
				} if ($inQuote == 0) {
					$section = "\$$section";
					$section =~ s/(^\s*)//;
					$section =~ s/\band\b/\&\&/g; 
					$section =~ s/\bor\b/\|\|/g; 
					$section =~ s/\bnot\b/\!\=/g;
				} 
			
		} 
		$letter .= " ";
		$letter .= $section;
	}


	if ($letter =~ /\[/) {
		@section = split ("\\[", $letter); 
		$letter = "$section[0]\[\$$section[1]";
	}
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
	@words = split (" ", $section,);
	$name = "$words[1] $words[2] $words[3]";
	$words = "while \($name\) \{";
	return $words; 
}

sub convertIf { 
	$section = convertAssignment($_[0]);
	$section =~ s/\$if//; 
	$section =~ s/\$&&/&&/; 
	$words = "if \($section\) \{";
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
	$words[5] = $words[5] - 1;
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

sub convertArray { 
	$section = $_[0]; 
	@words = split ("=", $section);
	$name = $words[0];
	$arraySection = $words[1]; 
	$arraySection =~ s/\[//g;
	$arraySection =~ s/\]//g;
	$arraySection =~ s/ //g;
	$words = "\@$name = \( $arraySection \)";
	return $words;
}

sub convertElse { 
	$words = "else \{";
	return $words; 
}