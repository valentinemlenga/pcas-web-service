package WebService::Model::LEAF;
use base qw{Catalyst::Model::DBIC::Schema};
use NEXT;
#use Moose;

__PACKAGE__->config(
    schema_class => 'WebService::Schema',
    connect_info => [
    'dbi:ODBC:cas_school_pages',
    'cas_school_pages',
    'cas_school_pages',



#        WebService->config->{db}{dsn},
#        WebService->config->{db}{user} || WebService->config->{db}{username},
#        WebService->config->{db}{pass} || WebService->config->{db}{password},
#        {
#            %{ WebService->config->{db}{params} },
#            quote_char => [ '[', ']' ],
#            name_sep   => '.',
        #},
    ],
);

