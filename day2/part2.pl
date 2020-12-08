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
		my ($pos1, $pos2, $letter, $password) = ($1, $2, $3, $4);

		my $count = 0;
		$count += letter_at_index($letter, $pos1, $password);
		$count += letter_at_index($letter, $pos2, $password);
		$valid_count++ if $count == 1;
	}
}

print "$valid_count\n";

sub letter_at_index
{
	my ($letter, $index, $string) = @_;

	my @letters = split(//,$string);

	return 1 if $letters[$index-1] eq $letter;
	return 0;
}
