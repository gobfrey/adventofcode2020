#!/usr/bin/perl

use strict;
use warnings;

my $file = $ARGV[0];
die "day1.pl *input_file*\n" unless $file;

open my $fh, "<$file" or die "couldn't open $file";

my $forms = parse_input($fh);

use Data::Dumper;
print STDERR Dumper $forms;

my $sum = 0;
foreach my $form (@{$forms})
{
	my @qs = keys %{$form};
	$sum += scalar @qs;
}
print "$sum\n";

sub parse_input
{
	my ($fh) = @_;

	my $forms = [];
	my $current_form = {};
	push @{$forms}, $current_form;

	while (<$fh>)
	{
		my $line = $_;
		chomp $line;

		if ($line eq '')
		{
			$current_form = {};
			push @{$forms}, $current_form;
		}

		foreach my $letter (split //, $line)
		{
			$current_form->{$letter}++;
		}
	}

	return $forms;
}

