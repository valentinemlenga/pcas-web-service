package WebService::Model::DBConn;

use Moose;
use namespace::autoclean;
BEGIN {extends 'Catalyst::Model::DBI'; }

use Data::Dumper;

__PACKAGE__->config(
    dsn           => 'DBI:ODBC:cas_school_pages',
    user          => 'cas_school_pages',
    password      => 'cas_school_pages',
    options       => { RaiseError => 1, AutoCommit => 0 },

);
#    dsn           => 'DBI:ODBC:pass2014',
#    user          => 'pass2014',
#    password      => '5QhkV7qr',
#    options       => { RaiseError => 1, AutoCommit => 0 },
#);

=head1 NAME

WebService::Model::DBConn - DBI Model Class

=head1 SYNOPSIS

See L<WebService>

=head1 DESCRIPTION

DBI Model Class.

NOTES: Setting AutoCommit to false because we want to treat this import
as one whole transaction. If we fail during any query, we should rollback
the entire transaction.

STATUS CODES:

1  => Success
1010 => Error connecting to database
20 => Error parsing XML
1030 => Error creating evaluator record
1040 => Error importing evaluator ratings
1050 => Error importing mean ratings
1060 => Duplicate Record 
70 => No CAS ID 

=head1 METHODS

=head2 import_evaluation

Takes the deserialized xml and dispatches the import process to 
appropriate methods

=cut
=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
