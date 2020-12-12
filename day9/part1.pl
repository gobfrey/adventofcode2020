#!/usr/bin/perl

use strict;
use warnings;

my $file = $ARGV[0];
die "day1.pl *input_file*\n" unless $file;

open my $fh, "<$file" or die "couldn't open $file";

my $NUMBERS = parse_input($fh);
my $preamble_size = 25;

foreach my $i (0 .. $#{$NUMBERS})
{
	print STDERR "Checking $i - " . $NUMBERS->[$i] . "\n";
	if (!check_number($i, $preamble_size))
	{
		print "INVALID\n";
		last;
	}
}

sub check_number
{
	my ($index, $preamble_size) = @_;

	return 1 if ($index - ($preamble_size+1) < 0);

	my $number = $NUMBERS->[$index];

	foreach my $i ( ($index - ($preamble_size+1)) .. ($index-1) )
	{
		foreach my $j ( ($index - ($preamble_size+1)) .. ($index-1) )
		{
			return 1 if $NUMBERS->[$i] + $NUMBERS->[$j] == $number;
		}
	}
	return 0;
}


sub parse_input
{
	my ($fh) = @_;

	my $numbers = [];

	while (<$fh>)
	{
		my $line = $_;
		chomp $line;

		push @{$numbers}, $line;
	}


	return $numbers;
}

