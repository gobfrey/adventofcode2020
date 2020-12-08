#!/usr/bin/perl

use strict;
use warnings;

my $file = $ARGV[0];
die "day1.pl *input_file*\n" unless $file;

open my $fh, "<$file" or die "couldn't open $file";


my $passports = parse_input($fh);


my $valid_count = 0;
foreach my $passport (@{$passports})
{
	$valid_count += valid_passport($passport);
}

print "$valid_count\n";


sub valid_passport
{
	my ($passport) = @_;

	my $required_fields = [qw/ byr iyr eyr hgt hcl ecl pid  /];

	foreach my $fieldname (@{$required_fields})
	{
		return 0 unless $passport->{$fieldname};
	} 
	return 1;
}


sub parse_input
{
	my ($fh) = @_;

	my $passports = [{}];

	while (<$fh>)
	{
		my $line = $_;
		chomp $line;

		if ($line eq '')
		{
			push @{$passports}, {};
			next;
		}

		my @fields = split(/ /,$line);

		foreach my $field (@fields)
		{
			my ($key, $value) = split(/:/, $field);
			$passports->[$#{$passports}]->{$key} = $value;
		}

	}

	return $passports;
}
