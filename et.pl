#!/usr/bin/env perl

use warnings;
use strict;
use CGI qw/:standard/;
use CGI::Carp qw/fatalsToBrowser/;
use File::stat;

use lib 'webex';
use lib 'yammer';
use lib 'lync';

use Webex;
use Yammer;
use Lync;

print header;
print start_html;

my $emails = param('emails');
my @emails = split(/\n/,$emails);

my $webex = param('webex');
my $yammer = param('yammer');
my $lync = param('lync');

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
		$email=lc($email);
		if(!exists($webex_db{$email})){
			print "$email does not have a webex account<br>";
		}else{
			print "deactivating ".$email.": ".Webex::deactivate($webex_db{$email})."<br>";
		}
	}
}

if((defined($yammer)) && $yammer eq 'on'){

	#does our token work?
	my $token_access = Yammer::test_token;
	if($token_access eq '401 Unauthorized'){
		print "invalid or expired yammer token, obtain a new token";
		goto END;
	}

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

	my %yammer_db = do 'yammer.db';

	foreach my $email (@emails){
		$email =~ s/\s+//g;
		$email = lc($email);

		next if($email eq '');

		if(!exists($yammer_db{$email})){
			print "cant find $email. maybe user is already deactivated?<br>";
		}else{
			print "deactivating ".$email.": ".Yammer::deactivate($yammer_db{$email}),"<br>";
		}
	}
}

if((defined($lync)) && $lync eq 'on'){

	print "lync accounts:<br>";

	foreach my $email (@emails){
		$email =~ s/\s+//g;
		$email = lc($email);

		next if($email eq '');

		print "deactivating ".$email.": ".Lync::deactivate($email),"<br>";
	}
}

END:
print end_html;
