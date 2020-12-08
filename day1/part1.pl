#!/usr/bin/perl

use strict;
use warnings;

my $file = "input.txt";

open FILE, "<$file" or die "couldn't open $file";

my @numbers;

while (<FILE>)
{
	chomp;
	push @numbers, $_;
}

foreach my $i (0 .. $#numbers)
{
	foreach my $j ($i .. $#numbers)
	{
		if ($numbers[$i]+$numbers[$j] == 2020)
		{
			print $numbers[$i]*$numbers[$j] . "\n";
		}
	}
}

