#!/usr/bin/env perl
use strict;
use warnings;
use JSON::PP;

my ($mode, $field, $baseline_path, $unset_path, $present_path, $hidden_path) = @ARGV;
die "usage: $0 mode field baseline unset present [hidden]\n" unless $present_path;
sub read_json {
  my ($path) = @_;
  open my $file, '<:raw', $path or die "$path: $!\n";
  local $/;
  return decode_json(<$file>);
}
my $json = JSON::PP->new->canonical;
my $baseline = read_json($baseline_path);
my $unset = read_json($unset_path);
my $present = read_json($present_path);
die "$mode.$field: unset changed text, shapes, pages, or positions\n"
  unless $json->encode($baseline) eq $json->encode($unset);
die "$mode.$field: positive control did not print anything different\n"
  if $json->encode($baseline) eq $json->encode($present);
if ($hidden_path) {
  die "$mode.$field: hidden marks left output or spacing\n"
    unless $json->encode($baseline) eq $json->encode(read_json($hidden_path));
}
my $printed = join '', map { $_->{text} } grep { $_->{kind} eq 'printed' } @$baseline;
die "$mode.$field: missing required text\n"
  unless $printed =~ /Required title/ && $printed =~ /Body/;
$printed =~ s/Required title|Participant|Author|Body|Question|Statement|[0-9]|\s//g;
die "$mode.$field: unwanted label or separator: $printed\n" if length $printed;

my $expected = read_json('tests/assets/omission-anchors.json');
sub assert_y {
  my ($record, $value, $name) = @_;
  die "$mode.$field: missing $name anchor\n" unless $record;
  die "$mode.$field: $name moved from $value to $record->{y}\n"
    if abs($record->{y} - $value) > 0.00001;
}
my ($title) = grep { $_->{text} eq 'Required title' && $_->{page} == 1 } @$baseline;
my ($author) = grep { $_->{text} eq 'Participant' && $_->{page} == 1 } @$baseline;
my ($notch) = grep { $_->{kind} eq 'shape' } @$baseline;
assert_y($title, $expected->{$mode}{title}, 'title');
assert_y($author, $expected->{$mode}{author}, 'author');
assert_y($notch, $expected->{$mode}{notch}, 'notch');
my @anchors = grep { $_->{kind} eq 'anchor' } @$baseline;
die "$mode.$field: expected exactly two body anchors\n" unless @anchors == 2;
my $first_page = $mode eq 'report' ? 2 : 1;
die "$mode.$field: unexpected empty or front-matter page\n"
  unless $anchors[0]{page} == $first_page && $anchors[1]{page} == $first_page + 1;
assert_y($anchors[0], $expected->{$mode}{body}, 'body') unless $field eq 'marks';
assert_y($anchors[1], $expected->{'second-body'}, 'second body');
print "ok    rendered omission $mode.$field\n";
