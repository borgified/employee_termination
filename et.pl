#!/usr/bin/env perl

use warnings;
use strict;
use CGI qw/:standard/;
use CGI::Carp qw/fatalsToBrowser/;

print header;
print start_html;
my $emails = param('emails');

my @emails = split(/\n/,$emails);
foreach my $item (@emails){
	chomp($item);
	print "$item<br>";
}

my $webex = param('webex');

if ($webex eq 'on'){
	foreach my $email (@emails){
	}
}

print end_html;
