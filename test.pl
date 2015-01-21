#!/usr/bin/env perl

use warnings;
use strict;

use lib 'webex';

use Webex qw/deactivate list/;

#print &deactivate("djanbaz");
#&list;

use File::stat;

my $a=stat('webex.db')->mtime;

#print $a;
print time - $a;


#if((time - $a) < 3600){

