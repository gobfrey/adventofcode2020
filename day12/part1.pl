#!/usr/bin/perl

use strict;
use warnings;

my $file = $ARGV[0];
die "day1.pl *input_file*\n" unless $file;

open my $fh, "<$file" or die "couldn't open $file";

my $directions = parse_input($fh);

my $EAST = 0;
my $NORTH = 0;
my $FACING = 0;

my $instructions = {
	'N' => sub {
		my ($amount) = @_;
		$NORTH += $amount;
	},
	'S' => sub {
		my ($amount) = @_;
		$NORTH -= $amount;
	},
	'E' => sub {
		my ($amount) = @_;
		$EAST += $amount;
	},
	'W' => sub {
		my ($amount) = @_;
		$EAST -= $amount;
	},
	'L' => sub {
		my ($amount) = @_;
		$FACING -= $amount;
		$FACING += 360;
		$FACING = $FACING % 360;
	},
	'R' => sub {
		my ($amount) = @_;
		$FACING += $amount;
		$FACING = $FACING % 360;
	},
	'F' => sub {
		my ($amount) = @_;

		my $cardinal_facing = convert_facing();

		$NORTH += $amount if $cardinal_facing eq 'N';
		$NORTH -= $amount if $cardinal_facing eq 'S';
		$EAST += $amount if $cardinal_facing eq 'E';
		$EAST -= $amount if $cardinal_facing eq 'W';
	}

};

foreach my $d (@{$directions})
{
	&{$instructions->{$d->{direction}}}($d->{amount});
}

print "$EAST $NORTH\n";
print abs($EAST) + abs($NORTH) . "\n";

sub convert_facing
{
	return 'E' if ($FACING == 0);
	return 'S' if ($FACING == 90);
	return 'W' if ($FACING == 180);
	return 'N' if ($FACING == 270);

	die "unexpected facing $FACING\n";
}

sub parse_input
{
	my ($fh) = @_;

	my $directions = [];

	while (<$fh>)
	{
		my $line = $_;
		chomp $line;

		my ($direction, $amount) = split(//,$line,2);
		push @{$directions}, {direction => $direction, amount => $amount};
	}


	return $directions;
}

