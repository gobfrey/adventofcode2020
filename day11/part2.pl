#!/usr/bin/perl

use strict;
use warnings;

my $file = $ARGV[0];
die "day1.pl *input_file*\n" unless $file;

open my $fh, "<$file" or die "couldn't open $file";

my $map = parse_input($fh);
output_map($map);
my $counts = count_neighbour_states($map, 0,0);


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
		&& ($counts->{'#'} >=5)
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
		'L' => 0,
		'#' => 0
	};

	foreach my $row_step( -1, 0, 1 )
	{
		foreach my $col_step( -1, 0 ,1 )
		{
			next if ($row_step == 0 && $col_step == 0);
			my $state = first_seat_in_direction($map, $row+$row_step, $col+$col_step, $row_step, $col_step);
			$counts->{$state}++ if $state;
		}
	}

	return $counts;
}

sub first_seat_in_direction
{
	my ($map, $row, $col, $row_step, $col_step) = @_;

	my $state = state_at_location($map, $row, $col);

	return undef unless $state;

	if ($state eq '.')
	{
		return first_seat_in_direction($map, $row + $row_step, $col + $col_step, $row_step, $col_step);
	}

	return $state;
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

