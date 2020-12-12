#!/usr/bin/perl

use strict;
use warnings;

my $file = $ARGV[0];
die "day1.pl *input_file*\n" unless $file;

open my $fh, "<$file" or die "couldn't open $file";

my $directions = parse_input($fh);

my $SHIP = { E => 0, N => 0 };
my $WAYPOINT = { E => 10, N => 1 };

my $instructions = {
	'N' => sub {
		my ($amount) = @_;
		$WAYPOINT->{N} += $amount;
	},
	'S' => sub {
		my ($amount) = @_;
		$WAYPOINT->{N} -= $amount;
	},
	'E' => sub {
		my ($amount) = @_;
		$WAYPOINT->{E} += $amount;
	},
	'W' => sub {
		my ($amount) = @_;
		$WAYPOINT->{E} -= $amount;
	},
	'L' => sub {
		my ($amount) = @_;

		while ($amount > 0)
		{
			rotate_left();
			$amount -= 90;
		}

	},
	'R' => sub {
		my ($amount) = @_;

		while ($amount > 0)
		{
			rotate_right();
			$amount -= 90;
		}

	},
	'F' => sub {
		my ($amount) = @_;

		$SHIP->{E} += $WAYPOINT->{E} * $amount;
		$SHIP->{N} += $WAYPOINT->{N} * $amount;
	}

};

foreach my $d (@{$directions})
{
	&{$instructions->{$d->{direction}}}($d->{amount});

	print "Direction: ". $d->{direction} . $d->{amount} . "\n";
	print "Ship: ", $SHIP->{E} . ' ' . $SHIP->{N} . "\n";
	print "Waypoint: ", $WAYPOINT->{E} . ' ' . $WAYPOINT->{N} . "\n";

}

use Data::Dumper;
print Dumper $SHIP;
print Dumper $WAYPOINT;

print abs($SHIP->{N}) + abs($SHIP->{E}) . "\n";

sub rotate_right
{
	my $new_e = $WAYPOINT->{N};
	my $new_n = -$WAYPOINT->{E};

	$WAYPOINT->{E} = $new_e;
	$WAYPOINT->{N} = $new_n;

}

sub rotate_left
{
	my $new_e = -$WAYPOINT->{N};
	my $new_n = $WAYPOINT->{E};

	$WAYPOINT->{E} = $new_e;
	$WAYPOINT->{N} = $new_n;

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

