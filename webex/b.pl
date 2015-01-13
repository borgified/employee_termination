#!/usr/bin/env perl

use warnings;
use strict;

use LWP::UserAgent;
use HTTP::Request::Common;

my %config = do '/secret/employee_termination.config';

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
<bodyContent xsi:type="java:com.webex.service.binding.meeting.LstsummaryMeeting" xmlns:meet="http://www.webex.com/schemas/2002/06/service/meeting">
<listControl>
<startFrom/>
<maximumNum>5</maximumNum>
</listControl>
<order>
<orderBy>STARTTIME</orderBy>
</order>
<dateScope>
</dateScope>
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

print $res->content;
print $res->status_line;
