#!/usr/bin/perl

use strict;
use warnings;

my $file = $ARGV[0];
die "day1.pl *input_file*\n" unless $file;

open my $fh, "<$file" or die "couldn't open $file";

my $voltages = parse_input($fh);

my $input_voltage = 0;
my $gap_counts = {};

foreach my $voltage (sort {$a <=> $b} @{$voltages})
{
	my $gap = $voltage - $input_voltage;

	$gap_counts->{$gap}++;
	print "$input_voltage -> $voltage ($gap)\n";

	$input_voltage = $voltage;
}
$gap_counts->{3}++; #maximum final output

use Data::Dumper;
print Dumper $gap_counts;

print $gap_counts->{1} * $gap_counts->{3} . "\n";

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

