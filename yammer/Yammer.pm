package Yammer;

use warnings;
use strict;
use Exporter;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = ();
@EXPORT_OK   = qw(deactivate list);
%EXPORT_TAGS = ( DEFAULT => [qw(&deactivate &list)]);

use LWP::UserAgent;
use HTTP::Request::Common;

use XML::Simple qw(:strict);
use Data::Dumper;

my %config = do '/secret/employee_termination.config';

sub deactivate {
}

sub list{
}
