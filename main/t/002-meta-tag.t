# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 4;
BEGIN { 
use_ok('WebSource') ;
use_ok('WebSource::Logger') ;
use_ok('WebSource::MetaTag');
};

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $ws = new WebSource(
	wsd => "t/002-meta-tag.xml",
#	logger => new WebSource::Logger(level => 6)
);
$ws->query(data => 'dummy');
my $res = $ws->next_result();
ok($res->{hello} eq 'bonjour','Output exists and is correct');
