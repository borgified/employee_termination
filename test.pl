#!/usr/bin/env perl

use warnings;
use strict;

use lib 'webex';

use DeactivateUser qw/deactivate/;

print &deactivate("djanbaz");
