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
		foreach my $k ($j .. $#numbers)
		{
			next if $i == $k || $i == $j;

			my $sum = 0;
			my $product = 1;

			foreach my $index ($i, $j, $k)
			{
				$sum += $numbers[$index];
				$product *= $numbers[$index]
			}

			if ($sum == 2020)
			{
				print "$product\n"; 
			}
		}
	}
}

