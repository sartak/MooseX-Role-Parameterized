#!/usr/bin/env perl
package MooseX::Role::Parameterized::Meta::Role::Parameterizable;
use Moose;
extends 'Moose::Meta::Role';

use MooseX::Role::Parameterized::Meta::Role::Parameterized;
use MooseX::Role::Parameterized::Parameters;

has parameter_metaclass => (
    is      => 'rw',
    isa     => 'Moose::Meta::Class',
    lazy    => 1,
    default => sub {
        Moose::Meta::Class->create_anon_class(
            superclasses => ['MooseX::Role::Parameterized::Parameters'],
        );
    },
);

has role_generator => (
    is        => 'rw',
    isa       => 'CodeRef',
    predicate => 'has_role_generator',
);

sub add_parameter {
    my $self = shift;
    $self->parameter_metaclass->add_attribute(@_);
}

sub construct_parameters {
    my $self = shift;
    $self->parameter_metaclass->construct_instance(@_);
}

sub generate_role {
    my $self = shift;
    my %args = @_;

    confess "A role generator is required to generate roles"
        unless $self->has_role_generator;

    my $parameters = $self->construct_parameters(%args);

    my $metaclass = Moose::Meta::Class->create_anon_class(
        superclasses => ['MooseX::Role::Parameterized::Meta::Role::Parameterized'],
    );
    my $role = $metaclass->construct_instance(
        parameters => $parameters,
    );

    local $MooseX::Role::Parameterized::CURRENT_METACLASS = $role;
    $self->role_generator->($parameters,
        operating_on => $role,
    );

    return $role;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

