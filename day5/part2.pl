#!/usr/bin/perl

use strict;
use warnings;

my $file = $ARGV[0];
die "day1.pl *input_file*\n" unless $file;

open my $fh, "<$file" or die "couldn't open $file";

my $test_seat = 'FBFBBFFRLR';
my $test_seat_number = convert_boarding_pass($test_seat);
print "$test_seat_number\n";

my $seats = parse_input($fh);

use Data::Dumper;
print STDERR Dumper $seats;

foreach my $i (0 .. $#{$seats})
{
	next if $i == 0;
	next if ($seats->[$i]);
	next if (!$seats->[$i-1]);
	next if (!$seats->[$i+1]);
	print "My Seat is $i\n";
}


sub parse_input
{
	my ($fh) = @_;

	my $seats = [];
	while (<$fh>)
	{
		my $line = $_;
		chomp $line;

		my $seat_number = convert_boarding_pass($line);

		$seats->[$seat_number] = 1;
	}
	return $seats;
}

sub convert_boarding_pass
{
	my ($code) = @_;

	if ($code =~ m/^([FB]{7})([LR]{3})$/)
	{
		my ($front, $side) = ($1, $2);

		my $row = binary_search(0,127,$front);
		my $column = binary_search(0,7,$side);
		
		return ($row * 8) + $column;
	}
	else
	{
		print STDERR "Invalid seat code: $code\n";
	}
}


sub binary_search
{
	my ($min, $max, $splits) = @_;

	print STDERR "Searching $min $max $splits\n";

	foreach my $split (split(//,$splits))
	{
		if ($split eq 'F' || $split eq 'L')
		{
			($min, $max) = lower_half($min, $max);
		}
		if ($split eq 'B' || $split eq 'R')
		{
			($min, $max) = upper_half($min, $max);
		}
	}

	if ($max != $min)
	{
		print STDERR "$max != $min after search\n";
	}
	else
	{
		print STDERR "Found $max\n";
	}

	return $max;
}

sub upper_half
{
	my ($min, $max) = @_;

	my $middle = ($max - $min) / 2;
	my $new_min = (int $middle) + 1 + $min;

	print STDERR "UPPER $min,$max => $new_min, $max\n";

	return ($new_min, $max);
}

sub lower_half
{
	my ($min, $max) = @_;

	my $middle = ($max - $min) / 2;
	my $new_max = (int $middle) + $min;

	print STDERR "LOWER $min,$max => $min, $new_max\n";
	return ($min, $new_max);
}
