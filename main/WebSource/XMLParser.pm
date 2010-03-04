package WebSource::XMLParser;
use strict;
use LWP::UserAgent;
# use WebSource::Parser;
use WebSource::Module;
use Carp;
use Encode;
use Encode::Guess;

our @ISA = ('WebSource::Module');

my %html_options = (
  recover => 1,
  encoding => 'UTF-8'
);

=head1 NAME

WebSource::XMLParser : Builds a document out of an http-response
containing an XML or HTML file

=head1 DESCRIPTION

An XMLParser operator is declared as follows :

 <ws:xmlparser name="opname" forward-to="ops"/>


=head1 SYNOPSIS

  $fetcher = WebSource::XMLParser->new(wsnode => $node);

  # for the rest it works as a WebSource::Module

=head1 METHODS

=over 2

=item B<< $parser = WebSource::XMLParser->new(desc => $node); >>

Create a new Fetcher;

=cut

sub _init_ {
  my $self = shift;
  $self->SUPER::_init_;
  $self->{parser}         or $self->{parser} = XML::LibXML->new;
  return $self;
}


=item B<< $parser->handle($env); >>

Parses the content of an http-response

=cut

sub handle {
  my $self = shift;
  my $env = shift;
 
  $env->type eq "text/html" or
  ( $env->type eq "text/xml"  or
     return () );
 
  my $ct = $env->data;
  my $base = $env->{baseuri};
  my $doc = eval {
    $self->log(5,"Found doctype of '". $env->type . "'");
    if ($env->type eq "text/html") {
      $self->{parser}->parse_html_string($ct,\%html_options);
    } else {
      $self->{parser}->parse_string($ct);
    }
  };
  if(!$doc) {
    $self->log(1,"Couldn't parse document $base : $@");
    $self->log(6,">> here is the content <<\n",$ct,"\n");
    return ();
  }
  my %meta = %$env;
  return WebSource::Envelope->new(
           %meta,
           type    => "object/dom-node",
           baseuri => $base,
           data    => $doc);
}

=back 2

=head1 SEE ALSO

WebSource::Module

=cut

1;
