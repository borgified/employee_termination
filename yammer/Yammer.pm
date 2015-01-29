package Yammer;

use warnings;
use strict;
use Exporter;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = ();
@EXPORT_OK   = qw(deactivate list);
%EXPORT_TAGS = ( DEFAULT => [qw(&deactivate &list)]);

use LWP::UserAgent;
use HTTP::Request::Common;

use Data::Dumper;
use JSON;

my %config = do '/secret/yammer.conf';

sub deactivate {
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
			print OUTPUT "\'$item->{email}\' => \'$item->{id}\'\n";
		}

		$page++;

	} while ($res->content ne '[]' && $res->status_line eq '200 OK');

	close(OUTPUT);

	return $res->status_line;
}

1;
