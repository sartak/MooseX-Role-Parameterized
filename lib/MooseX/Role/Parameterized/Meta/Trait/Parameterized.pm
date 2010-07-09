package MooseX::Role::Parameterized::Meta::Trait::Parameterized;
use Moose::Role;

our $VERSION = '0.19';

use MooseX::Role::Parameterized::Parameters;

has genitor => (
    is       => 'ro',
    isa      => 'MooseX::Role::Parameterized::Meta::Role::Parameterizable',
    required => 1,
);

has parameters => (
    is  => 'rw',
    isa => 'MooseX::Role::Parameterized::Parameters',
);

no Moose::Role;

1;

__END__

=head1 NAME

MooseX::Role::Parameterized::Meta::Trait::Parameterized - trait for parameterized roles

=head1 DESCRIPTION

This is the trait for parameterized roles; that is, parameterizable roles with
their parameters bound. All this actually provides is a place to store the
L<MooseX::Role::Parameterized::Parameters> object as well as the
L<MooseX::Role::Parameterized::Meta::Role::Parameterizable> object that
generated this role object.

=head1 ATTRIBUTES

=head2 genitor

Returns the L<MooseX::Role::Parameterized::Meta::Role::Parameterizable>
metaobject that generated this role.

=head2 parameters

Returns the L<MooseX::Role::Parameterized::Parameters> object that represents
the specific parameter values for this parameterized role.

=cut

