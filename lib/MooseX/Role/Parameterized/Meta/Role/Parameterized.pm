package MooseX::Role::Parameterized::Meta::Role::Parameterized;
use Moose;
extends 'Moose::Meta::Role';

# ABSTRACT: metaclass for parameterized roles

has parameters => (
    is  => 'rw',
    isa => 'MooseX::Role::Parameterized::Parameters',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

