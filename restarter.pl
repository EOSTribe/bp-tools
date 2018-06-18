use strict;
use Net::SMS::TextmagicRest;
# Author: Eugene Luzgin @ EOS Tribe
# Install TextMagic:
# https://www.textmagic.com/docs/api/perl/
# Crete account, get API key at https://www.textmagic.com/


my @DATADIRS = ("REPLACE-WITH-EOS-NODE-DATA-DIR");
my @PHONES = ("YOUR-CELL-NUMBER");
my $tm = Net::SMS::TextmagicRest->new(
    username => "ACCOUNT",
    token    => "API-KEY",
);


foreach my $datadir (@DATADIRS) {
	open LOG, ">>$datadir/restart.log";
	# Check if file flag exists:
	if(-f "$datadir/RESTART_FAILED") {
		print LOG "Restart failed! Exiting\n";
		close LOG;
		exit 1;
	}
	# Check if process started and restart if needed:
	my @nodeos_process = `ps -ef | grep "nodeos" | grep "$datadir"`;
	my $proc_count = scalar @nodeos_process;
	if($proc_count < 2) {
		my $rt = `$datadir/start.sh`;
		my $log_entry = gmtime()." - Restarting node : $datadir/start.sh ";
		sleep 3;
		my @nodeos_restarted = `ps -ef | grep "nodeos" | grep "$datadir"`;
		my $restarted_proc_count = scalar @nodeos_restarted;
		if($restarted_proc_count < 2) {
			$log_entry.=" [FAILED], ";
			`touch $datadir/RESTART_FAILED`;
		} else { 
			$log_entry.=" [OK], ";
		}
		# Send SMS Alert:
		my $result = $tm->send(
   			text    => $log_entry,
    			phones  => \@PHONES,
		);
		$log_entry .= " SMS[$result->{id}]\n";
		print LOG $log_entry;
	}
	close LOG;
}
