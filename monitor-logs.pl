use File::Tail;
use Net::SMS::TextmagicRest;
# Author: Eugene Luzgin @ EOS Tribe
# Install TextMagic:
# https://www.textmagic.com/docs/api/perl/
# Crete account, get API key at https://www.textmagic.com/


my @PHONES = ("YOUR-CELL-NUMBER");
my $tm = Net::SMS::TextmagicRest->new(
    username => "USERNAME",
    token    => "ACCESS-KEY",
);

# Change values to yours:
my $producer = "eostribeprod";
my $nodedir = "/home/eosproducer/Mainnet/producer-node";

my @REGDATA = `$nodedir/cleos.sh system listproducers`;
my $bp_position = "50+";
my $counter = 0;
foreach my $regbp (@REGDATA) {
   if($regbp=~m/^(\w+)\s+(EOS\w+)\s/) {
      $counter++;
      if($1 eq $producer) { $bp_position = $counter };	
   }
}
print "Current position: $bp_position\n";

if($bp_position <= 21) {
	my $total_missed_blocks = 0;
	my $produce_block_count = 0;
        my $line_count = 0;
        my $produce_turn_count = 0;
	my $file = File::Tail->new("$nodedir/stderr.txt");
	my $last_block = "";
        my $other_blocks_count = 0;
	while (defined(my $line= $file->read)) {
	    $line_count++;
	    if($line=~m/produce_block/) {
		if($produce_block_count==0) {
			$produce_turn_count++;
		}
		$produce_block_count++;
		if($line=~m/\s\#(\d+)\s\@/) {
			$last_block = $1;
		}
	    } elsif($line=~m/on_incoming_block/) {
		if($line=~m/\s\#(\d+)\s\@/) {
                        $new_block = $1;
			if($new_block <= $last_block) {
				print "$current_producer Producer: Got late block $new_block \n";
			} elsif($new_block > $last_block) {
				$other_blocks_count++;
			}
			if($other_blocks_count > 12) {
				if($produce_block_count > 0 and $produce_block_count < 12) {
                                        my $missed_blocks = 12-$produce_block_count;
                                        $total_missed_blocks += $missed_blocks;
                                        my $message = "$current_producer Producer: Missed $missed_blocks blocks [Total $total_missed_blocks] @ #$last_block\n";
					print $message;
					my $result = $tm->send(
				               text    => $message,
				               phones  => \@PHONES,
        				);
                                }
                                $produce_block_count = 0;
                                $last_block = "";
				$other_blocks_count = 0;
			}
                }
	    }
	}
}

