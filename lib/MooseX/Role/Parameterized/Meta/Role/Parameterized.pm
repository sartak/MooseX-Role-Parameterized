package MooseX::Role::Parameterized::Meta::Role::Parameterized;
use Moose;
extends 'Moose::Meta::Role';

our $VERSION = '0.10';

use MooseX::Role::Parameterized::Parameters;

has parameters => (
    is  => 'rw',
    isa => 'MooseX::Role::Parameterized::Parameters',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

__END__

=head1 NAME

MooseX::Role::Parameterized::Meta::Role::Parameterized - metaclass for parameterized roles

=head1 DESCRIPTION

This is the metaclass for parameteriz-ed roles; that is, parameteriz-able roles
with their parameters bound. All this actually provides is a place to store the
L<parameters> object.

=cut

