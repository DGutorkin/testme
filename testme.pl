#!/usr/bin/env perl

use 5.010;
use strict;
use warnings;
use File::stat;
use JSON qw//;
use File::Slurp qw/read_file/;
use Time::HiRes qw/sleep/;

use Data::Printer;
my %stats;

my $config = 'testme.json';
if ($ARGV[0] && $ARGV[1] && $ARGV[0] eq '-c') {
  $config = $ARGV[1];
}

unless (-e $config) {
  say "Configuration file is missing. Exit.";
  exit 1;
}

my $json_cfg = read_file($config) ;
my $data =  JSON->new->decode($json_cfg);

say "Watching for $data->{working_directory}"
  if $data->{working_directory};

while(1) {
  foreach my $target (@{$data->{targets}}) {
    test($target);
  }
  sleep $data->{sleep};
}

sub test {
  my $target = shift;
  foreach my $src (@{$target->{src}}) {
    my $fn = "$data->{working_directory}/$src";
    my $mtime = stat($fn)->[9];
    if (exists $stats{$fn}) {
      if ($stats{$fn} != $mtime) {
        system ($target->{test});
      }
    }
    $stats{$fn} = $mtime;
  }
}
1;
