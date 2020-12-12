#!/usr/bin/perl

use strict;
use warnings;

my $file = $ARGV[0];
die "day1.pl *input_file*\n" unless $file;

open my $fh, "<$file" or die "couldn't open $file";

my $NUMBERS = parse_input($fh);
#my $target_number = 127;
my $target_number = 144381670;

foreach my $i (0 .. $#{$NUMBERS})
{
	print STDERR "$i of " . $#{$NUMBERS} . "\n";

	next if $NUMBERS->[$i] == $target_number;

	my $sum = 0;
	my $sum_parts = {};

	my $j = $i;
	while ($sum < $target_number)
	{
		last if $j > $#{$NUMBERS};

		$sum += $NUMBERS->[$j];
		$sum_parts->{$NUMBERS->[$j]} = 1;
		$j++;
	}

	if ($sum == $target_number)
	{
		use Data::Dumper;
		print STDERR Dumper $sum_parts;

		my @sorted_parts = sort {$a <=> $b} keys %{$sum_parts};

		print $sorted_parts[0] + $sorted_parts[$#sorted_parts] . "\n";
		last;
	}

	$i++;
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

