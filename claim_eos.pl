use strict;
use Time::Piece;
# Author: Eugene Luzgin @ EOS Tribe

my $producer = "<producer-name>";
my $wallet_pswd = "<wallet-password>";
my $datadir = "/home/eostribe/Mainnet/producer-node"; #<- change path to yours
my $unlock_cmd = $datadir."/cleos.sh wallet unlock --password ".$wallet_pswd;
my $prodstats_cmd = $datadir."/cleos.sh get table eosio eosio producers -l 10000 | grep -A 7 ".$producer;
my $claim_cmd = $datadir."/cleos.sh system claimrewards $producer -p $producer";
my $time_diff_24h = 86400;
my $log_entry = "";

open LOG, ">>$datadir/claim.log";
my @prodstats = `$prodstats_cmd`;
my $last_claim_time = 0;
foreach my $stat (@prodstats) {
	if($stat=~m/"last_claim_time": "(\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d)\.\d\d\d"/) {
		my $tp = Time::Piece->strptime($1, "%Y-%m-%dT%H:%M:%S");
		$last_claim_time = $tp->epoch;;
	}
}
my $current_time = time();
if($last_claim_time > 0) {
	my $diff_time = $current_time - $last_claim_time;
	#print $last_claim_time."->".$current_time.": ".$diff_time. "\n";	
	# 24h period passed - call unlock wallet and claim:
	if($diff_time > $time_diff_24h) {
		#Unlock wallet:
		my $rt = `$unlock_cmd`;
		#Claim rewards:
		my @claim_response = `$claim_cmd`;
		$log_entry = join(' ', @claim_response);
	} else {
		print "Not time yet: ".($time_diff_24h-$diff_time)." secs left!\n";
	}
} else {
	$log_entry = "ERROR: Failed to get last claim time!";
}
if($log_entry) {
	print LOG $log_entry;
}
close LOG;
