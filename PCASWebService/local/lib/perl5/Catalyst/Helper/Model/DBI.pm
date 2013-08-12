package Catalyst::Helper::Model::DBI;

use strict;
use File::Spec;

our $VERSION = '0.28';

=head1 NAME

Catalyst::Helper::Model::DBI - Helper for DBI Models

=head1 SYNOPSIS

    script/create.pl model DBI DBI dsn user password

=head1 DESCRIPTION

Helper for DBI Model.

=head2 METHODS

=over 4

=item mk_compclass

Reads the database and makes a main model class

=item mk_comptest

Makes tests for the DBI Model.

=back 

=cut

sub mk_compclass {
    my ( $self, $helper, $dsn, $user, $pass ) = @_;
    $helper->{dsn}  = $dsn  || '';
    $helper->{user} = $user || '';
    $helper->{pass} = $pass || '';
    my $file = $helper->{file};
    $helper->render_file( 'dbiclass', $file );
    return 1;
}

=head1 SEE ALSO

L<Catalyst::Manual>, L<Catalyst::Test>, L<Catalyst::Request>,
L<Catalyst::Response>, L<Catalyst::Helper>

=head1 AUTHOR

Alex Pavlovic, C<alex.pavlovic@taskforce-1.com>

=head1 LICENSE

This library is free software . You can redistribute it and/or modify
it under the same terms as perl itself.

=cut

1;
__DATA__

__dbiclass__
package [% class %];

use strict;
use warnings;
use parent 'Catalyst::Model::DBI';

__PACKAGE__->config(
    dsn           => '[% dsn %]',
    user          => '[% user %]',
    password      => '[% pass %]',
    options       => {},
);

=head1 NAME

[% class %] - DBI Model Class

=head1 SYNOPSIS

See L<[% app %]>

=head1 DESCRIPTION

DBI Model Class.

=head1 AUTHOR

[% author %]

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
