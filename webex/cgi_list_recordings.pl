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
<bodyContent xsi:type="java:com.webex.service.binding.ep.LstRecording">
<listControl>
<startFrom>0</startFrom>
</listControl>
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

my $recordings = $xmlparse->{'serv:body'}->{'serv:bodyContent'}->{'ep:recording'};
my $total_records = $xmlparse->{'serv:body'}->{'serv:bodyContent'}->{'ep:matchingRecords'}->{'serv:total'};

my $remaining_records = $total_records;

my $n=0;

my %db;

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
<bodyContent xsi:type="java:com.webex.service.binding.ep.LstRecording">
<listControl>
<serv:startFrom>$start_from</serv:startFrom>
<serv:maximumNum>$max</serv:maximumNum>
</listControl>
</bodyContent>
</body>
</serv:message>
ENDOFXML


	$req->content($sendXML);
	$res = $ua->request($req);
	$xmlparse = XMLin($res->content, ForceArray => 0, KeyAttr => {},);
	$recordings = $xmlparse->{'serv:body'}->{'serv:bodyContent'}->{'ep:recording'};

	foreach my $item (@$recordings){
		#print $n++."------------\n";
		foreach my $key (sort keys %$item){
			#uncomment next line to see each info on each recording (also uncomment the above print to separate each record)
			#print "$key $$item{$key}\n";
		}
		#aggregate total size of each recording on a per user basis
		if(!exists($db{$$item{'ep:hostWebExID'}})){
			$db{$$item{'ep:hostWebExID'}}=$$item{'ep:size'};
		}else{
			$db{$$item{'ep:hostWebExID'}}+=$$item{'ep:size'};
		}
	}
	#print $res->status_line;
	$remaining_records -= 500;
}

my @keys = reverse sort { $db{$a} <=> $db{$b} } keys(%db);
my @vals = @db{@keys};

use CGI qw/:standard/;

print header,start_html;
print "<pre>";
foreach my $key (@keys){
	print "$key $db{$key}\n";
}
print "</pre>";
print end_html;


#print Dumper($xmlparse);

