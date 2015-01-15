#!/usr/bin/env perl

use warnings;
use strict;

binmode STDOUT, ":utf8";

use LWP::UserAgent;
use HTTP::Request::Common;

use XML::Simple qw(:strict);
use Data::Dumper;

my %config = do '/secret/employee_termination.config';

my $start_from = 1;
my $max=10;

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
<bodyContent xsi:type="java:com.webex.service.binding.user.LstsummaryUser">
<listControl>
<serv:listMethod>AND</serv:listMethod>
<serv:startFrom>$start_from</serv:startFrom>
<serv:maximumNum>$max</serv:maximumNum>
</listControl>
<order>
<orderBy>UID</orderBy>
<orderAD>ASC</orderAD>
</order>
<dataScope>
</dataScope>
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

my $users = $xmlparse->{'serv:body'}->{'serv:bodyContent'}->{'use:user'};
my $total_records = $xmlparse->{'serv:body'}->{'serv:bodyContent'}->{'use:matchingRecords'}->{'serv:total'};

my $remaining_records = $total_records;

my $n=0;

while($remaining_records > 0){

	$max = 500;
	$start_from=1+($total_records - $remaining_records);

	$sendXML = << "ENDOFXML";
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
<bodyContent xsi:type="java:com.webex.service.binding.user.LstsummaryUser">
<listControl>
<serv:listMethod>AND</serv:listMethod>
<serv:startFrom>$start_from</serv:startFrom>
<serv:maximumNum>$max</serv:maximumNum>
</listControl>
<order>
<orderBy>UID</orderBy>
<orderAD>ASC</orderAD>
</order>
<dataScope>
</dataScope>
</bodyContent>
</body>
</serv:message>
ENDOFXML


	$req->content($sendXML);
	$res = $ua->request($req);
	$xmlparse = XMLin($res->content, ForceArray => 0, KeyAttr => {},);
	$users = $xmlparse->{'serv:body'}->{'serv:bodyContent'}->{'use:user'};

	foreach my $item (@$users){
		print $n++."------------\n";
		foreach my $key (sort keys %$item){
			print "$key $$item{$key}\n";
		}
	}

	print $res->status_line;

	$remaining_records -= 500;
}





#print Dumper($xmlparse);

