package WebService::View::JSON;

use strict;
use base 'Catalyst::View::JSON';
use Data::Dumper; 
use JSON::XS ();

=head1 NAME

WebService::View::JSON - Catalyst JSON View

=head1 SYNOPSIS

See L<WebService>

=head1 DESCRIPTION

Catalyst JSON View.

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
__PACKAGE__->config(map => {
    'text/x-yaml' => 'YAML',
    'application/json' => 'JSON',
});

sub encode_json {
      my($self, $c, $data) = @_;
      my $encoder = JSON::XS->new->ascii->pretty->allow_nonref;
      $encoder->encode($data);
}

sub process {
    my ( $self, $c ) = @_;
    $c->response->headers->content_type('application/json');
    $c->response->output( Dumper $c->stash );
    return 1;
}



1;
