#!/usr/bin/perl

use strict;
use warnings;

my $file = $ARGV[0];
die "day1.pl *input_file*\n" unless $file;

open my $fh, "<$file" or die "couldn't open $file";

my $voltages = parse_input($fh);

my $COUNT_CACHE = {};

print count_paths(0, $voltages) . "\n";

sub count_paths
{
	my ($source_voltage, $voltages) = @_;


	return $COUNT_CACHE->{$source_voltage} if $COUNT_CACHE->{$source_voltage};

	my $child_voltages = [];
	my $highest_voltage = 0;

	foreach my $voltage (@{$voltages})
	{
		$highest_voltage = $voltage if $voltage > $highest_voltage;
		if (($voltage > $source_voltage) && ($voltage <= ($source_voltage +3)))
		{
			push @{$child_voltages}, $voltage;
		}
	}

	my $count = 0;
	if ($source_voltage == $highest_voltage)
	{
		$count = 1;
	}
	else
	{
		foreach my $child_voltage (@${child_voltages})
		{
			$count += count_paths($child_voltage, $voltages);
		}
	}

	$COUNT_CACHE->{$source_voltage} = $count;
	return $count;
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

