#!/usr/bin/perl
use strict;
use Data::Dumper;

my $file = shift or die "Give me a file\n";

open IN, "$file" or die $!;

my (%survey,@survey);
my $row;
while (<IN>) {
    chomp;
    if (++$row == 1) {
	(undef,undef,undef,@survey) = split("\t",$_);
    }
    else {
	(undef,undef,undef,my @cells) = split("\t",$_);
	my $z = @cells - 1;
	for my $i (0..$z) {
	    push @{$survey{$survey[$i]}}, $cells[$i];
	}
    }
}

for my $q (@survey) {
    my @answers = @{$survey{$q}};
    my %count;
    for my $answer (@answers) {
	$answer =~ s/"//g;
	$answer =~ s/\n/ /g;
	$count{$answer}++;
    }
    print "$q\n";
    my @ans;
    my $highest = 0;
    while (my ($k,$v) = each %count) {
	push @ans, [$v,$k];
	$highest = $v if $v > $highest;
    }

    print "Num\tAnswer\n" if $highest > 1;

    for my $ans (sort {$b->[0]<=>$a->[0]} @ans) {
	my ($num,$txt) = @$ans;
	$txt ||= 'Did not answer';
	my $retval;
	$retval = "$num\t" if $highest > 1;
	$retval .= "$txt\n";
	print $retval;
    }
    print "\n\n";
}
