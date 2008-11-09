#!/usr/bin/env perl
package MooseX::Role::Parameterized::Meta::Role::Parameterized;
use Moose;
extends 'Moose::Meta::Role';

has parameters => (
    is       => 'rw',
    isa      => 'MooseX::Role::Parameterized::Parameters',
    required => 1,
);

# we override get_method_map because this is an anonymous role, there's no
# package to check
sub get_method_map {
    my $self = shift;

    return $self->{'methods'} ||= {};
}

# we override add_method because we don't want to install methods added through
# this API; we just stick it in the method map
sub add_method {
    my ($self, $method_name, $method) = @_;
    (defined $method_name && $method_name)
    || Moose->throw_error("You must define a method name");

    if (!blessed($method)) {
        Moose->throw_error("You must pass a blessed method to add_method");
    }

    $self->get_method_map->{$method_name} = $method;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

