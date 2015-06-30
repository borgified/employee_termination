package AD;

use warnings;
use strict;
use Exporter;
use Net::OpenSSH;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = ();
@EXPORT_OK   = qw(deactivate);
%EXPORT_TAGS = ( all => [qw(&deactivate)],);

my %config = do '/secret/AD.conf';

sub deactivate{
	my $email = shift;

	my $login_error;
	my ($stdout,$stderr,$exit);

	my $ssh = Net::OpenSSH->new($config{nagios_server},
		user => $config{user},
		passwd => $config{passwd},
		ctl_dir => '/home/apache',
		master_opts => [-o => "StrictHostKeyChecking=no",
			-o => "UserKnownHostsFile=/home/apache/.ssh/known_hosts",
		],
	);

	my $output;

	if($ssh->error){
		$output = "cant ssh to $config{nagios_server}: ". $ssh->error;
		return $output;
	}

	my $capture = $ssh->capture({timeout => 30},"/usr/lib/nagios/plugins/check_nrpe -H $config{AD_server} -c disable_AD_user -a $email -t 30");

	if($capture =~ /OU=TermedUsers/){
		#if theres no output, it means it ran successfully
		$output = "deactivated";
	}else{
		#not sure what happened but ill show you the capture for debugging
		$output = "UNABLE to find this user. <br>reason: $capture";
	}


	return $output;

}


1;
