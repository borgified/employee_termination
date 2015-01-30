package Yammer;

use warnings;
use strict;
use Exporter;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = ();
@EXPORT_OK   = qw(deactivate list test_token get_token);
%EXPORT_TAGS = ( DEFAULT => [qw(&deactivate &list &test_token &get_token)]);

use LWP::UserAgent;
use HTTP::Request::Common;
use CGI qw/:standard/;
use Data::Dumper;
use JSON;

my %config = do '/secret/yammer.conf';

sub test_token {
	my $uri = 'https://www.yammer.com/api/v1/users/1514334666.json';

	my $ua = LWP::UserAgent->new;
	my $req = HTTP::Request->new(GET => $uri);

	$req->header('Authorization' => 'Bearer '. $config{'token'});

	my $res = $ua->request($req);
	return $res->status_line;
}

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
		print "update the value of \'token\' in /secret/yammer.conf with: $token and try again";

	}

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

sub list{
	open(OUTPUT, '>', 'yammer.db') or die "couldnt open yammer.db $!";

	my $page=1;
	my $ua = LWP::UserAgent->new;

	my $res;

	do {
		my $uri = "https://www.yammer.com/api/v1/users.json?page=$page";

		my $req = HTTP::Request->new(GET => $uri);

		$req->header('Authorization' => 'Bearer '. $config{'token'});


		$res = $ua->request($req);

		my $content = JSON->new->decode($res->content);

		foreach my $item (@$content){
			print OUTPUT "\'$item->{email}\' => \'$item->{id}\'\,\n";
		}

		$page++;

	} while ($res->content ne '[]' && $res->status_line eq '200 OK');

	close(OUTPUT);

	return $res->status_line;
}

1;
