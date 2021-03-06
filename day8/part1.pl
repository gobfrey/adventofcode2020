#!/usr/bin/perl

use strict;
use warnings;

my $file = $ARGV[0];
die "day1.pl *input_file*\n" unless $file;

open my $fh, "<$file" or die "couldn't open $file";

my $PROGRAM = parse_input($fh);
my $ACC = 0;
my $PC = 0;

execute_program();


sub execute_program
{
	my $executed = {};
	while (1)
	{
		if ($executed->{$PC})
		{
			print "$ACC\n";
			last;
		}
		$executed->{$PC} = 1;

		my $instruction = $PROGRAM->[$PC];	

		use Data::Dumper;
		print STDERR "Executing $PC :\n" . Dumper $instruction;

		my $fn = 'exe_' . $instruction->{opcode};
		my $subref = \&$fn;

		&{$subref}($instruction->{argument});

		print STDERR "ACC: $ACC\n";
	}
}

sub exe_nop
{
	$PC++;
}

sub exe_jmp
{
	my ($arg) = @_;

	$PC = add_signed_number($PC, $arg);
}

sub exe_acc
{
	my ($arg) = @_;

	$ACC = add_signed_number($ACC, $arg);
	$PC++;
}


sub add_signed_number
{
	my ($value, $signed_number) = @_;

	my ($sign, $number) = parse_signed_number($signed_number);

	$number = "-$number" if ($sign eq '-');

	return $value + $number;
}

sub parse_signed_number
{
	my ($signed_number) = @_;

	my $sign = substr $signed_number, 0, 1;
	my $number = substr $signed_number, 1;

	print STDERR "Parsing $signed_number -> '$sign' '$number'\n";

	return ($sign, $number);
}

sub parse_input
{
	my ($fh) = @_;

	my $program = [];

	while (<$fh>)
	{
		my $line = $_;
		chomp $line;

		my ($opcode, $argument) = split(/ /, $line);

		push @{$program}, {opcode => $opcode, argument => $argument};
	}


	return $program;
}

