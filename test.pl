#!/usr/bin/env perl

use warnings;
use strict;

use lib 'webex';

use Webex qw/deactivate/;

print &deactivate("djanbaz");
