package WebSource::Extract::xslt;
use strict;
use WebSource::Parser;
use XML::LibXSLT;
use Carp;

our @ISA = ('WebSource::Module');

=head1 NAME

WebSource::Extract::xslt - Apply an XSL Stylesheet to the input

=head1 DESCRIPTION

This flavor of the B<Extract> operator applies an XSL stylesheet to the input
an returns the transformation result.

Such an extraction operator should be described as follows :

  <ws:extract type="xslt" name="opname" forward-to="ops">
    <xsl:stylesheet>
    ...
    </xsl:stylesheet>
  </ws:extract>
  
  where the xsl prefix should be associated to the URI http://www.w3.org/1999/XSL/Transform

=head1 SYNOPSIS

=head1 METHODS

=cut

sub new {
  my $class = shift;
  my %params = @_;
  my $self = bless \%params, $class;
  $self->SUPER::_init_;
  my $wsd = $self->{wsdnode};
  if($wsd) {
    $wsd->setNamespace("http://www.w3.org/1999/XSL/Transform","xsl",0);
    my @stylesheet = $wsd->findnodes('xsl:stylesheet');
    if(@stylesheet) {
      my $wsdoc = $wsd->ownerDocument;
      my $xsltdoc = XML::LibXML::Document->new($wsdoc->version,$wsdoc->encoding);
      $xsltdoc->setDocumentElement($stylesheet[0]->cloneNode(1));
      my $xslt = XML::LibXSLT->new();
      $self->{xsl} = $xslt->parse_stylesheet($xsltdoc);
      $self->{format} = $wsd->getAttribute("format");
    } else {
      croak "No stylesheet found\n";
    }
  }
  $self->{xsl} or croak "No XSLT stylesheet given";
  return $self;
}

sub handle {
  my $self = shift;
  my $env = shift;

  $self->log(5,"Got document ",$env->{baseuri});
  my $data = $env->data;
  if(!$data->isa("XML::LibXML::Document")) {
    $self->log(5,"Creating document from DOM node");
    my $doc = XML::LibXML::Document->new("1.0","iso-8859-1");
    $doc->setDocumentElement($data->cloneNode(1));
    $data = $doc;
  }
  $self->log(6,"We have : \n".$data->toString(1)."\n");
  my $result = $self->{xsl}->transform($data);
  $self->{format} eq "document" or $result = $result->documentElement;
  $self->log(6,"Produced :\n",$result->toString(1));
  return WebSource::Envelope->new(type => "object/dom-node", data => $result);
}

=head1 SEE ALSO

WebSource

=cut

1;
