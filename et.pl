#!/usr/bin/env perl

use warnings;
use strict;
use CGI qw/:standard/;
use CGI::Carp qw/fatalsToBrowser/;
use File::stat;

use lib 'webex';
use lib 'yammer';

use Webex qw/deactivate list/;
use Yammer qw/deactivate list/;

print header;
print start_html;

my $emails = param('emails');
my @emails = split(/\n/,$emails);

my $webex = param('webex');
my $yammer = param('yammer');

if ((defined($webex)) && $webex eq 'on'){

	if(-e 'webex.db'){
		my $ts = stat('webex.db')->mtime;
		if(time - $ts < 3600){
			print "webex.db was generated < 1hr ago, using cache<br>";
		}else{
			print "webex.db > 1hr old, regenerating...<br>";
			Webex::list;
		}
	}else{
		print "webex.db doesn't exist, regenerating...<br>";
		Webex::list;
	}

	my %webex_db = do 'webex.db';

	foreach my $email (@emails){
		$email =~ s/\s+//g;
		next if($email eq '');
		print "deactivating lc($email): ".Webex::deactivate($webex_db{lc($email)});
		print "<br>";
	}
}

if((defined($yammer)) && $yammer eq 'on'){
	if(-e 'yammer.db'){
		my $ts = stat('yammer.db')->mtime;
		if(time - $ts < 3600){
			print "yammer.db was generated < 1hr ago, using cache<br>";
		}else{
			print "yammer.db > 1hr old, regenerating...<br>";
			Yammer::list;
		}
	}else{
		print "yammer.db doesn't exist, regenerating...<br>";
		Yammer::list;
	}
}


print end_html;
