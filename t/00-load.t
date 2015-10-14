use strict;
use warnings FATAL => 'all';
use Test::More;
use URI;
use Try::Tiny;
use v5.10;

use FindBin;
use lib "$FindBin::Bin/lib";

BEGIN {
	use_ok( 'WebService::E4SE' ) || BAIL_OUT("Can't use WebService::E4SE");
}

my $ws = WebService::E4SE->new();
can_ok('WebService::E4SE', (
	qw(_wsdls _ua base_url files force_wsdl_reload password realm site username), # attributes,
	qw(_get_port _valid_file _wsdl call get_object operations), # methods
));

isa_ok($ws,'WebService::E4SE');
isa_ok($ws->_ua(),'LWP::UserAgent');
ok($ws->username eq '');
ok($ws->username('foo') eq 'foo');
ok($ws->password eq '');
ok($ws->password('foo') eq 'foo');
ok($ws->realm eq '');
ok($ws->realm('foo') eq 'foo');
ok($ws->site eq 'epicor:80');
ok($ws->site('foo') eq 'foo');
isa_ok($ws->base_url(),'URI');
ok($ws->base_url eq 'http://epicor/e4se');
ok($ws->base_url(URI->new('http://foo.com')) eq 'http://foo.com');
isa_ok($ws->_wsdls, 'HASH');
ok($ws->force_wsdl_reload eq 0);
ok($ws->force_wsdl_reload(1) eq 1);
isa_ok($ws->files, 'ARRAY');


done_testing();
