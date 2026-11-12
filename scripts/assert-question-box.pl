#!/usr/bin/env perl
use strict;
use warnings;
use JSON::PP;
my ($mode, $hidden, $plain_path, $boxed_path) = @ARGV;
sub read_json {
  my ($path) = @_;
  open my $file, '<:raw', $path or die "$path: $!\n";
  local $/;
  return decode_json(<$file>);
}
my $plain = read_json($plain_path);
my $boxed = read_json($boxed_path);
my $inset = read_json('tests/assets/omission-anchors.json')->{'question-inset'};
for my $axis ('x', 'y') {
  my $actual = $boxed->{$axis} - $plain->{$axis};
  die "$mode: incorrect $axis inset when hidden=$hidden: $actual\n"
    if abs($actual - $inset->{$axis}) > 0.00001;
}
print "ok    rendered question inset $mode hidden=$hidden\n";
