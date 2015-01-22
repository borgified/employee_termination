#!/usr/bin/env perl

use warnings;
use strict;
use CGI qw/:standard/;
use CGI::Carp qw/fatalsToBrowser/;
use File::stat;

use lib 'webex';

use Webex qw/deactivate list/;

print header;
print start_html;

my $emails = param('emails');
my @emails = split(/\n/,$emails);

my $webex = param('webex');

if ($webex eq 'on'){

	if(-e 'webex.db'){
		my $ts = stat('webex.db')->mtime;
		if(time - $ts < 3600){
			print "webex.db was generated < 1hr ago, using cache<br>";
		}else{
			print "webex.db > 1hr old, regenerating...<br>";
			&list;
		}
	}else{
		print "webex.db doesn't exist, regenerating...<br>";
		&list;
	}

	my %webex_db = do 'webex.db';

	foreach my $email (@emails){
		$email =~ s/\s+//g;
		next if($email eq '');
		print "deactivating $email: ".&deactivate($webex_db{$email});
		print "<br>";
	}
}

print end_html;
