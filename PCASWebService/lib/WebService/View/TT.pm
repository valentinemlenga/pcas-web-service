package WebService::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
        TEMPLATE_EXTENSION => '.tt',
        INCLUDE_PATH => [
        WebService->path_to('templates'),
        WebService->config->{leafdir} . '/templates',
        ],
	TIMER => 0,
	render_die => 0,

        map => {
            'application/json' => 'JSON',
        },
);


1
