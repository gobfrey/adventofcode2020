#!/usr/bin/perl

use strict;
use warnings;

my $file = "input.txt";

open FILE, "<$file" or die "couldn't open $file";

my $map;
while (<FILE>)
{
	chomp;
	my @row = split(//,$_);
	push @{$map}, \@row;
}

my $product = 1;
foreach my $pair ([1,1],[3,1],[5,1],[7,1],[1,2])
{
	my $trees = trees_in_path($pair->[0], $pair->[1], $map);

	print "$trees\n";
	$product *= $trees;
}
print "$product\n";

sub trees_in_path
{
	my ($x_step, my $y_step, my $map) = @_;

	my $x = 0;
	my $tree_count = 0;
	for (my $y = 0; $y <= $#{$map}; $y += $y_step)
	{
		my $row = $map->[$y];

		my $x_actual = $x % scalar @{$row};

		$tree_count++ if $row->[$x_actual] eq '#';

		$x+=$x_step;
	}

	return $tree_count;
}

