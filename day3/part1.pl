#!/usr/bin/perl

use strict;
use warnings;

my $file = "input.txt";

open FILE, "<$file" or die "couldn't open $file";

my @numbers;

my $x = 0;
my $tree_count = 0;
while (<FILE>)
{
	chomp;

	my @row = split(//,$_);

	my $x_actual = $x % scalar @row;

	print STDERR @row,"$x_actual\n";

	$tree_count++ if $row[$x_actual] eq '#';

	$x+=3;
}

print "$tree_count\n";

