#!/usr/bin/env perl
package MooseX::Role::Parameterized;
use Moose;
use Moose::Role ();
extends 'Moose::Exporter';

use MooseX::Role::Parameterized::Meta::Role;

our $CURRENT_ROLE;

__PACKAGE__->setup_import_methods(
    with_caller => ['parameter', 'role'],
);

sub parameter {
    my $caller = shift;
    $caller->meta->add_parameter(@_);
}

sub role {
    my $caller         = shift;
    my $role_generator = shift;
    $caller->meta->role_generator($role_generator);
}

sub init_meta {
    my $self = shift;

    return Moose::Role->init_meta(@_,
        metaclass => 'MooseX::Role::Parameterized::Meta::Role',
    );
}

# give role a (&) prototype
around _make_wrapper => sub {
    my $orig = shift;
    my ($self, $caller, $sub, $fq_name) = @_;

    if ($fq_name =~ /::role$/) {
        return sub (&) { $sub->($caller, @_) };
    }

    return $orig->(@_);
};

1;

