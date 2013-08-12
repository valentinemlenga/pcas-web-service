use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'WebService' }
BEGIN { use_ok 'WebService::Controller::Rest' }

ok( request('/rest')->is_success, 'Request should succeed' );
done_testing();
