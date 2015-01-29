#!/usr/bin/env perl

use warnings;
use strict;

use LWP::UserAgent;
use HTTP::Request::Common;
use CGI qw/:standard/;
use JSON;
use Data::Dumper;

sub main {

	my %config = do '/secret/yammer.conf';

	print header,start_html;

	#does our token work? if not, get new one.

	my $test = &test_token;	

	if($test eq '401 Unauthorized'){
		print "time to get a token";	
	}

	#check to see if we have a recent cached list of yammer users

	print end_html;

#if($res->status_line eq '200 OK'){
#	print Dumper($res->content);
#}
#
#if($res->status_line eq '401 Unauthorized'){
#&get_token;
#}
#print "<br>".$res->status_line;

}

&main;


sub test_token {

	my $uri = 'https://www.yammer.com/api/v1/users/1514334666.json';

	my $ua = LWP::UserAgent->new;
	my $req = HTTP::Request->new(GET => $uri);

	$req->header('Authorization' => 'Bearer '. $config{'token'});


	my $res = $ua->request($req);
	return $res->status_line;

}





sub listusers {
	my $uri = 'https://www.yammer.com/api/v1/users.json';

	my $ua = LWP::UserAgent->new;
	my $req = HTTP::Request->new(GET => $uri);

	$req->header('Authorization' => 'Bearer '. $config{'token'});


	my $res = $ua->request($req);

	my @output;
	push($res->status_line,@output);
	push($res->content,@output);
	return \@output;
}



sub deactivate {

	my $id = shift;

	my $uri = "https://www.yammer.com/api/v1/users/$id.json";

	my $ua = LWP::UserAgent->new;
	my $req = HTTP::Request->new(DELETE => $uri);

	$req->header('Authorization' => 'Bearer '. $config{'token'});


	my $res = $ua->request($req);

	return $res->status_line;
}



#user authentication
#
#Once Yammer has successfully authenticated the user, the OAuth 2 dialog will prompt them to authorize the app. If the user clicks “Allow”, your app will be authorized. The OAuth 2 dialog will redirect the user’s browser via HTTP 302 to the redirect_uri with an authorization code: http://[:redirect_uri]?code=[:code]

sub get_token {

	if(!param('code')){

		my $url = "https://www.yammer.com/dialog/oauth?client_id=$config{'client_id'}&redirect_uri=$config{'redirect_uri'}";

		print "<a href=$url>login to get yammer code</a>";
	}else{

		my $code = param('code');
		my $url = "https://www.yammer.com/oauth2/access_token.json?client_id=$config{'client_id'}&client_secret=$config{'client_secret'}&code=$code"; 
		my $ua = LWP::UserAgent->new;
		my $req = HTTP::Request->new(GET => $url);
		my $res = $ua->request($req);

		my $content = JSON->new->decode($res->content);
		my $token = $content->{access_token}->{token};
		print "update the value of \'token\' in /secret/yammer.conf with: $token and rerun this.";

	}
}


#app authentication
#
#Submit a GET request on the OAuth Token Endpoint, passing in the authorization code you received above, plus your app secret. The endpoint is:https://www.yammer.com/oauth2/access_token.json?client_id=[:client_id]&client_secret=[:client_secret]&code=[:code] Yammer will return an access token object as part of the response, which includes user profile information. From this object, parse out and store the “token” property. This token will be used to make subsequent API calls to Yammer and will not expire.

#my $url = "https://www.yammer.com/oauth2/access_token.json?client_id=$config{'client_id'}&client_secret=$config{'client_secret'}&code=$config{'code'}"; 
#
#
#my $ua = LWP::UserAgent->new;
#my $req = HTTP::Request->new(GET => $url);
#
#my $res = $ua->request($req);
#
#
#print $res->content;
#
#print end_html;

__END__

my $uri = 'https://www.yammer.com/api/v1/users.json';
my $ua = LWP::UserAgent->new;
my $req = HTTP::Request->new(GET => $uri);

$req->header('Authorization' => 'Bearer '. $config{'token'});


my $res = $ua->request($req);

print $res->content;
print $res->status_line;

print end_html;






__END__


use lib 'WebService';

use WebService::Yammer;



my $consumer_key = $config{'client_id'};
my $consumer_secret = $config{'client_secret'};

my $y = WebService::Yammer->new(
consumer_key => $consumer_key,
consumer_secret => $consumer_secret
);

print $y->authorized



__END__

my $url = "https://www.yammer.com/dialog/oauth?client_id=$config{'client_id'}&redirect_uri=$config{'expected_redirect'}";
my $ua = LWP::UserAgent->new;

my $req = HTTP::Request->new(GET => $url);

my $res = $ua->request($req);

print $res->content,"\n",$res->status_line;



__END__

my $auth = "https://www.yammer.com/oauth2/access_token.json?client_id=$config{'client_id'}&client_secret=$config{'client_secret'}&code=$config{'code'}";

my $req = HTTP::Request->new(GET => $auth);




my $res = $ua->request($req);

print $res->content,"\n",$res->status_line,"\n",$res->as_string;





__END__


print $config{'client_id'};

my $url = 'https://api.yammer.com/api/v1/users.json';
my $ua = LWP::UserAgent->new;
my $req = HTTP::Request->new(GET => $url);


$req->content_type('application/json', 'Authorization' => 'Bearer '. $config{'token'});


my $res = $ua->request($req);

my $status = $res->status_line;
print $res->content;
print "\n---------\n";
print "$status\n";
