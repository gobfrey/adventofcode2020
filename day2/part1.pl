#!/usr/bin/perl

use strict;
use warnings;

my $file = "input.txt";

open FILE, "<$file" or die "couldn't open $file";

my @numbers;

my $valid_count = 0;
while (<FILE>)
{
	chomp;

	if ($_ =~ m/([0-9]+)-([0-9]+) (.): (.*)$/)
	{
		my ($min, $max, $letter, $password) = ($1, $2, $3, $4);

		my $count = count_letter($letter, $password);
		$valid_count++ if ($count >= $min && $count <= $max);
	}
}

print "$valid_count\n";

sub count_letter
{
	my ($letter, $string) = @_;

	my @letters = split(//,$string);

	my $counts = {};
	foreach my $l (@letters)
	{
		$counts->{$l}++;
	}

	return 0 unless $counts->{$letter};
	return $counts->{$letter};
}
