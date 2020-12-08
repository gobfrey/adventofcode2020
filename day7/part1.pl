#!/usr/bin/perl

use strict;
use warnings;

my $file = $ARGV[0];
die "day1.pl *input_file*\n" unless $file;

open my $fh, "<$file" or die "couldn't open $file";

my $rules = parse_input($fh);

use Data::Dumper;
print STDERR Dumper $rules;

foreach my $outer_bag ('muted yellow', 'light red')
{
	print "shiny gold in $outer_bag: ";
	print can_contain($outer_bag, 'shiny gold', $rules);
	print "\n";
}

my $count;
foreach my $bag (keys %{$rules})
{
	$count++ if can_contain($bag, 'shiny gold', $rules);
}

print "$count\n";

sub can_contain
{
	my ($outer_bag, $target_bag, $rules) = @_;

	print "->Checking $target_bag in $outer_bag\n";

	return 1 if $rules->{$outer_bag}->{$target_bag};

	foreach my $child (keys %{$rules->{$outer_bag}})
	{
		return 1 if can_contain($child, $target_bag, $rules);
	}
	return 0;
}



sub parse_input
{
	my ($fh) = @_;

	my $rules = {};

	while (<$fh>)
	{
		my $line = $_;
		chomp $line;

		if ($line =~ m/^(.*) bags contain/)
		{
			my $bag = $1;
			my $contains = {};
			while ($line =~ m/([0-9]+) ([a-z ]*) bag/g)
			{
				$contains->{$2} = $1;
			}
			$rules->{$bag} = $contains;
		}
	}

	return $rules;
}

