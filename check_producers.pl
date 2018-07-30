use strict;
use Net::SMS::TextmagicRest;
# Author: Eugene Luzgin @ EOS Tribe
# Install TextMagic:
# https://www.textmagic.com/docs/api/perl/
# Crete account, get API key at https://www.textmagic.com/


my $prod1_url = "http://<URL1>/v1/chain/get_info";
my $prod2_url = "http://<URL2>/v1/chain/get_info";

my @PHONES = ("CELL-PHONE");
my $tm = Net::SMS::TextmagicRest->new(
    username => "USERNAME",
    token    => "ACCESS-KEY",
);


my $prod1_stats = `curl --connect-timeout 2 $prod1_url`;
print "PRD1: ".$prod1_stats."\n";
my $prod2_stats = `curl --connect-timeout 2 $prod2_url`;
print "PRD2: ".$prod2_stats."\n";
my $message = "";

if($prod1_stats=~m/"head_block_num":(\d+)/) {
	my $prod1_head_block = $1;
	print "PRD1 Head Block: ".$prod1_head_block."\n";
	if($prod2_stats=~m/"head_block_num":(\d+)/) {
		my $prod2_head_block = $1;
		print "PRD2 Head Block: ".$prod2_head_block."\n";
		my $block_diff = $prod1_head_block - $prod2_head_block;
		print "Block diff: $block_diff\n";
		if($block_diff < -10) {
			$message = "1st producer $block_diff blocks behind 2nd producer!";
		} elsif($block_diff > 10) {
			$message = "2nd producer $block_diff blocks behind 1st producer!";
		}
	} else {
		$message = "2nd producer timeout!";
	}
} else {
	$message = "1st producer timeout!";
}

# Send SMS Alert if message set:
if($message ne "") {
	my $result = $tm->send(
               text    => $message,
               phones  => \@PHONES,
        );
	print "Sent $message SMS[$result->{id}]\n";
}

