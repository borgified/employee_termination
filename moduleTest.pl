#!/usr/bin/env perl

use warnings;
use strict;

use lib 'yammer';

use Yammer qw/deactivate list/;

my $status = Yammer::list;

print $status;
