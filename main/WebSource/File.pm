package WebSource::File;

use strict;
use WebSource::Module;
use Carp;
use DB_File;

our @ISA = ('WebSource::Module');

=head1 NAME

WebSource::File : Fetchs it input from a file (or standard
input if none is specified)

=head1 DESCRIPTION

A B<File> operator returns as item each line read from a file.

<ws:file name="opname"
    [ filename="file" ]
    forward-to="ops" />

The C<forward-to> and C<name> attributes have there usual signification.

The C<filename> attribut allows to set which file the items are read from.

=head1 SYNOPSIS

  $file = WebSource::File->new(wsnode => $node);

  # for the rest it works as a WebSource::Module

=head1 METHODS

=over 2

=item B<< $source = WebSource->new(desc => $node); >>

Create a new File module;

=cut

sub _init_ {
  my $self = shift;
  $self->SUPER::_init_;

  my $wsd = $self->{wsdnode};
  if($wsd) {
    $self->{filename} = $wsd->getAttribute("filename");
  }
  
  if ($self->{filename}) { 
    open($self->{fh},"<",$self->{filename});
  } else {
    $self->{filename} = "STDIN";
    $self-{fh} = *STDIN{IO};
  }
  $self->log(1,"Reading input data from ", $self->{filename}); 
}

=item B<< $file->handle($env); >>

Reads one line from the file and gives it as output;

=cut

sub handle {
  my $self = shift;
  my $env = shift;

  my $fh = $self->{fh};
  if(my $line = <$fh>) {
    chomp($line);
    $self->log(1,"Read '",$line,"' from ",$self->{filename});
    return WebSource::Envelope->new (
      type => "string"                                                                  "text/string" : "object/dom-node",
      data => $line,
    );
  } else {
    return undef;
  }
}

=back 2

=head1 SEE ALSO

WebSource::Module

=cut

1;
