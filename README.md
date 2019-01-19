# bp-tools
### EOS BP Tools 

#### restarter.pl - Perl script for monitoring/restarting EOS node and sending SMS alerts oon restart and fail.
##### Install as a cronjob on your system as often as you would like.
##### Before you could use the script:

##### 1. Install Perl if not installed

##### 2. Install Perl packages:

sudo cpan install String/CamelCase.pm

sudo cpan install Log::Log4perl

sudo cpan install JSON

sudo cpan install REST::Client

When running script - if you get message about missing module name,
just run: sudo cpan install module_name.

##### 3. Install TextMagic: https://github.com/textmagic/textmagic-rest-perl 

##### 4. Get account with TestMagic API: https://www.textmagic.com/docs/api/

### List of scripts:

#### restarter.pl - Automated script to detect and restart nodeos process.
NOTE: If restart fails - a flag file RESTART_FAILED is created and script stops running until file is removed.

#### vanity.sh - Find EOS key with certain short name in it by brute force

#### check_position.pl - Check producer position and notify if changed.

#### check_producers.pl - Compare head blocks of two producer nodes and notify if out of sync.

#### claim_eos.pl - Automated script to claim EOS BP rewards.

#### claim_eos_sms.pl - Automated script to claim EOS BP rewards with SMS notication.

#### claim_bos.pl - Automated script to claim BOS BP rewards.

#### claim_bos_sms.pl - Automated script to claim BOS BP rewards with SMS notication.

#### claim_wbi.pl - Automated script to claim Worbli BP rewards with SMS notication.

#### claim_uos.pl - Automated script to claim UOS BP rewards with SMS notication.

#### inspect_bp_keys.pl - Inspect registered producers keys and compare with account keys.

#### monitor-logs.pl - Monitor nodeos log (stderr.txt) in tail mode and detect missed blocks by active producer, notify by SMS.

Author: Eugene Luzgin @ EOS Tribe
Telegram: eluzgin
Email: eugene@eostribe.io


