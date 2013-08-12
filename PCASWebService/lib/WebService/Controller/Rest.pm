package WebService::Controller::Rest;
use Moose;
use namespace::autoclean;
use Data::Dumper;

use JSON;

BEGIN {extends 'Catalyst::Controller::REST'; $ENV{PERL_JSON_BACKEND} = 2 }

=head1 NAME

WebService::Controller::Rest - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->log->debug("RESPONSE: " . Dumper $c->response);
    $c->stash->{template} = 'index.tt';
    $c->response->content_type('text/html; charset=utf-8');
    $c->response->body('Matched WebService::Controller::Rest in Rest.  <br> <a href="schoolPage/">This is it.</a>');
  
}

sub schoolPage :Local :ActionClass('REST') { }

sub schoolPage_GET {
   my ( $self, $c ) = @_ ;

   $c->forward('processSchoolData');
   my $school_rs = $c->stash->{sNames};

   #$c->log->debug(Dumper($school_rs));  
   if ($school_rs ) {  
      #$c->log->debug(Dumper $self);
      delete $c->stash->{sNames};
      $self->status_ok($c, entity => { schools => $school_rs, }, );
   }
   #$c->stash->{template} = 'schoolpage.tt';
   $c->detach( $c->view("JSON") );
}

sub processSchoolData :Local {
   my ( $self, $c ) = @_;
 
  #my $schoolNames = $c->model('LEAF::School')->search()->all;
 
   my $schoolData =  $c->model('LEAF')->schema->storage->dbh->selectall_hashref(
       'SELECT  
	MAX(p.id)   AS ID, 
	MAX(s.NAME) AS schoolName, 
	MAX(p.NAME) AS schoolDescription,
	\'http://schoolpages.pharmcas.org/publishedsurvey/\' + CONVERT(Varchar(5), MAX(p.id))AS schoolPage,
	MAX(CASE WHEN p.ACTIVE=1 THEN \'true\' ELSE \'false\' END) AS participating,
	MAX(CASE WHEN a.leaflet_element_id = 1531 THEN oe.value_string END) AS state,
	MAX(CASE WHEN a.leaflet_element_id = 1534 THEN loe.value_string END) AS institutionType, 
	MAX(CASE WHEN a.leaflet_element_id = 1532 THEN lre.value_string END) AS accreditationStatus,
	MAX(CASE WHEN a.leaflet_element_id = 2006 THEN ye.value_string END) AS dualDegrees, 
	MAX(CASE WHEN a.leaflet_element_id = 1557 THEN ze.value_string END) AS suppRequired, 
	MAX(CASE WHEN a.leaflet_element_id = 1610 THEN answer END) AS deadline, 
	MAX(CASE WHEN a.leaflet_element_id = 1613 THEN answer END) AS fee, 
        MAX(CASE WHEN a.leaflet_element_id = 1538 THEN CASE WHEN answer = \'1\' THEN \'true\' ELSE CASE WHEN answer = \'0\' THEN \'False\' END END END) AS Eparticipating,
	MAX(CASE WHEN a.leaflet_element_id = 1558 THEN pe.value_string END) AS PCAT, 
	MAX(CASE WHEN a.leaflet_element_id = 1561 THEN te.value_string END) AS TOEFL, 
	MAX(CASE WHEN a.leaflet_element_id = 1533 THEN lpe.value_string END) AS pharmcasDeadline, 
	MAX(CASE WHEN a.leaflet_element_id = 1565 THEN ie.value_string END) AS proofOfStateResidencyRequired,
	MAX(CASE WHEN a.leaflet_element_id = 1567 THEN ne.value_string END) AS USResidencyRequired,
	MAX(CASE WHEN a.leaflet_element_id = 1569 THEN ee.value_string END) AS foreignCitizensConsidered
	 FROM assigned_surveys i 
	INNER JOIN programs p on i.program_id = p.id 
	INNER JOIN schools s  on p.school_id = s.id 
	INNER JOIN leaflet_instance_answers a ON i.leaflet_instance_id = a.leaflet_instance_id 
 	LEFT JOIN optionentry oe ON a.answer = oe.value_id AND oe.option_set_id = 1
 	LEFT JOIN optionentry pe ON a.answer = pe.value_id AND pe.option_set_id = 5
 	LEFT JOIN optionentry te ON a.answer = te.value_id AND te.option_set_id = 5
 	LEFT JOIN optionentry ie ON a.answer = ie.value_id AND ie.option_set_id = 5
 	LEFT JOIN optionentry ne ON a.answer = ne.value_id AND ne.option_set_id = 5
 	LEFT JOIN optionentry ee ON a.answer = ee.value_id AND ee.option_set_id = 5
 	LEFT JOIN optionentry ye ON a.answer = ye.value_id AND ye.option_set_id = 5
 	LEFT JOIN optionentry ze ON a.answer = ze.value_id AND ze.option_set_id = 44
 	LEFT JOIN leaflet_optionentry loe ON a.answer = loe.value_id AND loe.leaflet_element_id = 1534 
 	LEFT JOIN leaflet_optionentry lpe ON a.answer = lpe.value_id AND lpe.leaflet_element_id = 1533 
 	LEFT JOIN leaflet_optionentry lre ON a.answer = lre.value_id AND lre.leaflet_element_id = 1532
	WHERE a.leaflet_element_id IN (1531, 1532, 1534, 1533, 1538, 2006, 1557, 1610, 1613, 1558, 1561, 1565, 1567, 1569, 1723) 
  	  AND i.survey_id = 6
	GROUP BY a.leaflet_instance_id 
        ORDER BY 1', 'schoolName'
    );

    $c->forward('formatData', [ $schoolData ] );
}


sub formatData : Private {
  my ( $self, $c, $sData ) = @_;

  # Create Hash of Arrays for all Children fields.
  my %HofArrays    = ( generalInformation        => [ qw( participating pharmcasDeadline institutionType accreditationStatus dualDegrees ) ],
                       supplementalRequirements  => [ qw( required deadline fee) ],
                       earlyDecisionProgram      => [ qw( Eparticipating ) ],
                       tests                     => [ qw( PCAT TOEFL ) ],
                       residency                 => [ qw( proofOfStateResidencyRequired USResidencyRequired foreignCitizensConsidered ) ],
                     );

   # Loop through all schools found.
   foreach my $school ( keys % { $sData } ) {
      #$c->log->debug("school: $school");
      # Loop through all Parent fields (keys) with Children.
      foreach my $field (keys %HofArrays ) {
         #$c->log->debug("Field: $field");
         #$c->log->debug("Dump Field:" .  Dumper( $HofArrays{$field}));
         # Loop through each child array and insert parent/Child row into sData hash.
         foreach my $childField ( @{$HofArrays{$field}} ) {
            #$c->log->debug("childField: " .  $childField);
            #$c->log->debug("HofArrays{field}{childField}: " . $childField);
            #$c->log->debug("Child Answer: " . $sData->{$school}->{$childField});
            # Insert the child field to sData
            $sData->{$school}->{$field}->{$childField} = $sData->{$school}->{$childField};
            # Delete the origina field to prevent redundancy
            delete( $sData->{$school}->{$childField} );
	}	

      } 
  }
  my $json = encode_json $sData;
  #$c->log->debug('sData: ' . Dumper $json);
  
  my $jsonSchoolData  = encode_json $sData;
  $c->stash->{sNames} = $jsonSchoolData;
}


sub end : Private {
  my ( $self, $c ) =  @_;
  if ( $c->stash->{data} ) {
    $c->forward('View::JSON');
    return 1;
  }

  return;
}


=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
