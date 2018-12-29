use strict;
use Net::SMS::TextmagicRest;
# Author: Eugene Luzgin @ EOS Tribe
# Install TextMagic:
# https://www.textmagic.com/docs/api/perl/
# Crete account, get API key at https://www.textmagic.com/


my @PHONES = ("YOUR-CELL-NUMBER"); #<-- CHANGE THIS 
my $tm = Net::SMS::TextmagicRest->new(
    username => "YOUR-TEXTMAGIC-ACCOUNT", #<-- CHANGE THIS
    token    => "YOUR-TEXTMAGIC-API-KEY", #<-- CHANGE THIS
);;

my $producer = "YOUR-PRODUCER-NAME"; #<-- CHANGE THIS
my $wallet_pswd = "YOUR-WALLET-PASSWORD"; #<-- CHANGE THIS
my $datadir = "/home/eostribe/worbli-mainnet"; #<-- CHANGE THIS
my $unlock_cmd = $datadir."/worbli.sh wallet unlock --password ".$wallet_pswd;
my $prodstats_cmd = $datadir."/worbli.sh get table eosio eosio producers -l 10000 | grep -A 7 ".$producer;
my $claim_cmd = $datadir."/worbli.sh system claimrewards $producer -p $producer > $datadir/claim.log";
my $balance_cmd = $datadir."/worbli.sh get currency balance eosio.token $producer > $datadir/balance.log";
my $time_diff_24h = 86400;

my @prodstats = `$prodstats_cmd`;
my $last_claim_time = 0;
foreach my $stat (@prodstats) {
	if($stat=~m/"last_claim_time": "(\d+)"/) {
		$last_claim_time = $1/1000000;
	}
}
my $current_time = time();
if($last_claim_time > 0) {
	my $diff_time = $current_time - $last_claim_time;
	#print $last_claim_time."->".$current_time.": ".$diff_time. "\n";	
	# 24h period passed - call unlock wallet and claim:
	if($diff_time > $time_diff_24h) {
		#Unlock wallet:
		`$unlock_cmd`;
		#Claim rewards:
		`$claim_cmd`;
		my $claim_amt;
		# Read Log:
		open CLOG, "$datadir/claim.log";
		while (my $row = <CLOG>) {
			# Example: {"from":"eosio.ppay","to":"eostribe","quantity":"794.4896 WBI","memo":"producer block pay"}
			if($row=~m/"from":"eosio.ppay","to":"$producer","quantity":"(\d+\.\d+) WBI"/) {
				$claim_amt = $1;
			}
		}
		close CLOG;
		# Get new Balance:
		`$balance_cmd`;	
		# Read Log:
                open BLOG, "$datadir/balance.log";
                my $balance_amt = <BLOG>;
                close BLOG;
		my $notice = "WBI Claimed: $claim_amt\nNew Balance: $balance_amt";
                #print $notice;
		# Send SMS Alert:
                my $bal_result = $tm->send(
                        text    => $notice,
                        phones  => \@PHONES,
                );
		# Backup logs with timestamp:
		if(!-d "$datadir/claimlogs") {
			`mkdir $datadir/claimlogs`;
		}
		`cp $datadir/claim.log $datadir/claimlogs/claim-$current_time.log`;
		`cp $datadir/balance.log $datadir/claimlogs/balance-$current_time.log`;
	} 
} 

