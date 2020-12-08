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
		return 0 unless valid_field($fieldname, $passport->{$fieldname});
	} 
	return 1;
}

sub valid_field
{
	my ($fieldname, $value) = @_;

	my $validators = {
		'byr' => sub {
			my ($val) = @_;
			return ($val && ($val >= 1920) && ($val <= 2002));
		},
		'iyr' => sub {
			my ($val) = @_;
			return ($val && ($val >= 2010) && ($val <= 2020));
		},
		'eyr' => sub {
			my ($val) = @_;
			return ($val && ($val >= 2020) && ($val <= 2030));
		},
		'hgt' => sub {
			my ($val) = @_;
			if ($val =~ m/^([0-9]+)(cm|in)$/)
			{
				my ($amount, $units) = ($1, $2);
				return 1 if ($units eq 'cm') && ($amount >= 150) && ($amount <= 193);
				return 1 if ($units eq 'in') && ($amount >= 59) && ($amount <= 76);
			}
			return 0;
		},
		'hcl' => sub {
			my ($val) = @_;
			return 1 if $val =~ m/^#[0-9a-f]{6}$/;
			return 0;
		},
		'ecl' => sub {
			my ($val) = @_;
			my $valid_colours = [qw/ amb blu brn gry grn hzl oth /];
			foreach my $colour (@{$valid_colours})
			{
				return 1 if $val eq $colour;
			}
			return 0;
		},
		'pid' => sub {
			my ($val) = @_;
			return 1 if $val =~ m/^[0-9]{9}$/;
			return 0;
		},
		'cid' => sub {
			return 1;
		}
	};


	print STDERR "Validating $fieldname / $value";

	my $valid = &{$validators->{$fieldname}}($value);

	print STDERR " -> $valid \n";

	return $valid;
	
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
