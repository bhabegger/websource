package WebSource::File;

use strict;
use WebSource::Module;
use Carp;
use DB_File;
use IO::Handle;

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

=item B<< $file->handle($env); >>

Reads one line from the file and gives it as output;

=cut

sub handle {
  my $self = shift;
  my $env = shift;
  
  my $file = $env->data;
  my $io = IO::Handle->new();
  if($file eq 'stdin') {
    $io->fdopen(fileno(STDIN),"r");
  } else {
    $io->open($file,"r");
  }

  map {
    chomp;
    $self->log(1,"Read '",$_,"' from ",$file);
    WebSource::Envelope->new (
      type => "text/string",
      data => $_,
    );
  } <$io>;  
}

=back 2

=head1 SEE ALSO

WebSource::Module

=cut

1;
