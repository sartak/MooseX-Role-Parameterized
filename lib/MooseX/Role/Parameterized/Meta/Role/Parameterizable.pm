package MooseX::Role::Parameterized::Meta::Role::Parameterizable;
use Moose;
extends 'Moose::Meta::Role';

# ABSTRACT: metaclass for parameterizable roles

use MooseX::Role::Parameterized::Meta::Role::Parameterized;
use MooseX::Role::Parameterized::Parameters;

use constant parameterized_role_metaclass => 'MooseX::Role::Parameterized::Meta::Role::Parameterized';

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
    my $name = shift;

    # need to figure out a plan for these guys..
    confess "The parameter name ($name) is currently forbidden."
        if $name eq 'alias'
        || $name eq 'excludes';

    $self->parameter_metaclass->add_attribute($name => @_);
}

sub construct_parameters {
    my $self = shift;
    my %args = @_;

    # need to figure out a plan for these guys..
    for my $name ('alias', 'excludes') {
        confess "The parameter name ($name) is currently forbidden."
            if exists $args{$name};
    }

    $self->parameter_metaclass->new_object(\%args);
}

sub generate_role {
    my $self = shift;

    my $parameters = @_ == 1 ? shift
                             : $self->construct_parameters(@_);

    confess "A role generator is required to generate roles"
        unless $self->has_role_generator;

    my $role = $self->parameterized_role_metaclass->create_anon_role(parameters => $parameters);

    local $MooseX::Role::Parameterized::CURRENT_METACLASS = $role;
    $self->role_generator->($parameters,
        operating_on => $role,
    );

    return $role;
}

sub apply {
    my $self  = shift;
    my $class = shift;
    my %args  = @_;

    my $role = $self->generate_role(%args);
    $role->apply($class, %args);
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

