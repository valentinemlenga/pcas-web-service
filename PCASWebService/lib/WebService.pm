package WebService;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
/;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

# Configure the application.
#
# Note that settings in webservice.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'WebService',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
);

__PACKAGE__->config( 'Plugin::ConfigLoader' => {
    driver => {
        'General' => { -InterPolateVars => 1 }
    }
} );

__PACKAGE__->config->{static} = {
        dirs => ['js', 'style', 'html', 'uploads', 'images', 'help'],
        include_path => ['htdocs'],
};

__PACKAGE__->config->{session} = {
        dbic_class => 'LEAF::Session',
        expires => 3600 * 24 * 100, # 100 Days
        flash_to_stash => 1,
};

__PACKAGE__->config->{default_view} = 'TT';

__PACKAGE__->config->{'View::JSON'} = {
        expose_stash => 'json_data',
};



# Start the application
__PACKAGE__->setup();

=head1 NAME

WebService - Catalyst based application

=head1 SYNOPSIS

    script/webservice_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<WebService::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
