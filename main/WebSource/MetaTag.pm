package WebSource::MetaTag;

use WebSource::Module;

use strict;
use Carp;

our @ISA = ('WebSource::Module');

=head1 NAME

WebSource::MetaTag -  Set/update meta data associated with the input content

=head1 DESCRIPTION

A B<ws:meta-tag> operator allows to set or change one or more meta-data entries of the input objects

A typical meta-tag is to change force the content-type of the input :

  <ws:meta-tag name="correct-tags" forward-to="ops">
  	<tag name="Content-Type" value="application/rss+xml">
  </ws:format>

=cut

sub _init_ {
  my $self = shift;
  $self->SUPER::_init_;
  my %tags;
  my %dynTags;
  my $wsd = $self->{wsdnode};
  if($wsd) {
    foreach my $tagEl ($wsd->findnodes("tag")) {
    	my $key    = $tagEl->getAttribute("name");
    	my $source = $tagEl->getAttribute("source");
    	$source or $source = 'static';
    	if($source eq 'static') {
    	  my $value  = $tagEl->getAttribute("value");
    	  $tags{$key} = $value;
        } elsif ($source eq 'content') {
          $dynTags{$key} = 1;
        }
    }
  }
  $self->{staticTags} = \%tags;
  $self->{dynamicTags} = \%dynTags;
  return $self;
}


sub handle {
  my $self = shift;
  my $env = shift;
  my %tags = %{$self->{staticTags}};
  foreach my $dynTag (keys(%{$self->{dynamicTags}})) {
    $tags{$dynTag} = $env->data;
  }
  if($self->will_log(3)) {
	$self->log(3,"Forcing meta tags: " . join(", ", map { $_  . "=" . $tags{$_} } keys(%tags)));  	
  }
  return WebSource::Envelope->new(
  	%$env,
  	%tags
  );
}

=head1 SEE ALSO

WebSource, WebSource::Envelope

=cut

1;
