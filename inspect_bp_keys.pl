#!/usr/bin/perl

my @REGDATA = `./cleos.sh system listproducers`;


foreach my $regbp (@REGDATA) {
   if($regbp=~m/^(\w+)\s+(EOS\w+)\s/) {
        my $bp = $1; 
        my $regkey = $2;
        my $isacckey = 0;
        @BPDATA = `./cleos.sh get account $bp`;
        foreach $bpln (@BPDATA) {
            if($bpln=~m/$regkey/) {
                print $bp.' Account key: '.$bpln;
                $isacckey = 1;
            }
        }
        if($isacckey==0) {
                print $bp.' Signature key: '.$regkey."\n";
        }
   }
}

