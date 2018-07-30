use strict;
use Net::SMS::TextmagicRest;
# Author: Eugene Luzgin @ EOS Tribe
# Install TextMagic:
# https://www.textmagic.com/docs/api/perl/
# Crete account, get API key at https://www.textmagic.com/

# Change values:
my $node_dir = "/home/eostribe/Mainnet/producer-node";
my $producer = "eostribeprod";

my @PHONES = ("CELL-PHONE");
my $tm = Net::SMS::TextmagicRest->new(
    username => "USERNAME",
    token    => "TOKEN",
);

open LOG, "<$node_dir/bp_position.last";
my $last_position = <LOG>;
chomp $last_position;
close LOG;


my @REGDATA = `$node_dir/cleos.sh system listproducers`;
my $bp_position = "50+";
my $counter = 0;
foreach my $regbp (@REGDATA) {
   if($regbp=~m/^(\w+)\s+(EOS\w+)\s/) {
      $counter++;
      if($1 eq $producer) { $bp_position = $counter };	
   }
}


if($bp_position!=$last_position) {
	my $message = "$producer moved #".$last_position." -> #".$bp_position;
	open LOG, ">$node_dir/bp_position.last";
	print LOG $bp_position;
	close LOG;

# Send SMS Alert if message set:
	my $result = $tm->send(
               text    => $message,
               phones  => \@PHONES,
        );
	print "Sent $message SMS[$result->{id}]\n";
}

