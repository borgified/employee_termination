#!/usr/bin/env perl

use warnings;
use strict;
use CGI qw/:standard/;

use Yammer;

print header,start_html;

Yammer::get_token;

print end_html;
