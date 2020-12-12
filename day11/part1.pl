#!/usr/bin/perl

use strict;
use warnings;

my $file = $ARGV[0];
die "day1.pl *input_file*\n" unless $file;

open my $fh, "<$file" or die "couldn't open $file";

my $map = parse_input($fh);

while (1)
{
	my $change_count = step_map($map);
	last if ($change_count == 0);

	output_map($map);
}

my $counts = count_map_states($map);
use Data::Dumper;
print Dumper $counts;


sub count_map_states
{
	my ($map) = @_;

	my $counts = {};
	foreach my $r (0 .. $#{$map})
	{
		foreach my $c (0 .. $#{$map->[$r]})
		{
			my $state = generate_next_state($map, $r, $c);
			$counts->{$state}++;
		}
	}

	return $counts;
}

sub output_map
{
	my ($map) = @_;

	foreach my $row (@{$map})
	{
		print @{$row}, "\n";
	}
	print "\n\n";
}


sub step_map
{
	my ($map) = @_;

	my $changes = generate_changes($map);
	apply_changes($map, $changes);

	my $change_count = scalar @{$changes};
	return $change_count;
}

sub apply_changes
{
	my ($map, $changes) = @_;

	foreach my $change (@{$changes})
	{
		$map->[$change->{row}]->[$change->{column}] = $change->{state};
	}
}

sub generate_changes
{
	my ($map) = @_;

	my $changes = [];

	foreach my $r (0 .. $#{$map})
	{
		foreach my $c (0 .. $#{$map->[$r]})
		{
			my $new_state = generate_next_state($map, $r, $c);
			if ($new_state ne $map->[$r]->[$c])
			{
				push @{$changes}, {row => $r, column => $c, state => $new_state};
			}
		}
	}
	return $changes;
}

sub generate_next_state
{
	my ($map, $row, $col) = @_;

	my $state = state_at_location($map, $row, $col);

	return $state if $state eq '.';

	my $counts = count_neighbour_states($map, $row, $col);
	if (
		$state eq 'L'
		&& ($counts->{'#'} == 0)
	)
	{
		return '#';
	}
	if (
		$state eq '#'
		&& ($counts->{'#'} >=4)
	)
	{
		return 'L';
	}
	return $state;
}

sub count_neighbour_states
{
	my ($map, $row, $col) = @_;

	my $counts = {
		'.' => 0,
		'L' => 0,
		'#' => 0
	};
	foreach my $r ($row-1 .. $row+1)
	{
		foreach my $c ($col-1 .. $col+1)
		{
			my $state = state_at_location($map, $r, $c);
			$counts->{$state}++ if $state;
		}
	}
	$counts->{state_at_location($map, $row, $col)}--; #don't count this cell

	return $counts;
}

sub state_at_location
{
	my ($map, $row, $col) = @_;

	return undef if ($row < 0 || $row > $#{$map});
	return undef if ($col < 0 || $col > $#{$map->[$row]});

	return $map->[$row]->[$col];
}


sub parse_input
{
	my ($fh) = @_;

	my $map = [];

	while (<$fh>)
	{
		my $line = $_;
		chomp $line;

		my @row = split(//,$line);
		push @{$map}, \@row;
	}


	return $map;
}

