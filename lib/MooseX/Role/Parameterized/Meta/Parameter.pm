package MooseX::Role::Parameterized::Meta::Parameter;
use Moose;
extends 'Moose::Meta::Attribute';

our $VERSION = '0.26';

__PACKAGE__->meta->make_immutable;
no Moose;

1;

__END__

=head1 NAME

MooseX::Role::Parameterized::Meta::Parameter - metaclass for parameters

=head1 DESCRIPTION

This is the metaclass for parameter objects, a subclass of
L<Moose::Meta::Attribute>. Its sole purpose is to make the default value
of the C<is> option C<ro>.

=cut

