#!/usr/bin/env perl

use warnings;
use strict;

use lib 'yammer';
use Yammer;

#test obtaining new token
#can temporarily disable token by editing token's value in /secret/yammer.conf

my $token_access = Yammer::test_token;
if($token_access eq '401 Unauthorized'){
	Yammer::get_token;
}



#test listing users
#outputs to yammer.db
#status = 200 OK
#my $status = Yammer::list;
#print $status;
