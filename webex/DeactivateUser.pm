package DeactivateUser;

use warnings;
use strict;
use Exporter;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = ();
@EXPORT_OK   = qw(deactivate);
%EXPORT_TAGS = ( DEFAULT => [qw(&deactivate)]);

binmode STDOUT, ":utf8";

use LWP::UserAgent;
use HTTP::Request::Common;

use XML::Simple qw(:strict);
use Data::Dumper;

my %config = do '/secret/employee_termination.config';

sub deactivate {
	my $webexuser = shift @_;

	my $sendXML = << "ENDOFXML";
<?xml version="1.0" encoding="UTF-8"?>
<serv:message xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:serv="http://www.webex.com/schemas/2002/06/service">
<header>
<securityContext>
<webExID>$config{uid}</webExID>
<password>$config{pwd}</password>
<siteID>$config{sid}</siteID>
<partnerID>$config{pid}</partnerID>
</securityContext>
</header>
<body>
<bodyContent xsi:type="java:com.webex.service.binding.user.SetUser">
<webExId>$webexuser</webExId>
<active>DEACTIVATED</active>
</bodyContent>
</body>
</serv:message>
ENDOFXML

	my $url = "https://$config{xml_site}:$config{xml_port}/WBXService/XMLService";

	my $ua = LWP::UserAgent->new;

	my $req = HTTP::Request->new(POST => $url);

	$req->content_type('application/xml');

	$req->content($sendXML);

	my $res = $ua->request($req);

	my $xmlparse = XMLin($res->content, ForceArray => 0, KeyAttr => {},);

#print Dumper($xmlparse);

#print $res->status_line;
	my $result = Dumper($xmlparse)."<br>".$res->status_line;

	return($result);

}


1;
