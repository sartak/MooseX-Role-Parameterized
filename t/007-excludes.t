#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 3;
use Test::Exception;

do {
    package MyRole::Excluder;
    use MooseX::Role::Parameterized;

    parameter exclude => (
        is  => 'rw',
        isa => 'Str',
    );

    role {
        my $p = shift;
        excludes $p->exclude;
    };
};

Moose::Meta::Role->create("Role::A");
Moose::Meta::Role->create("Role::B");

my @keep_roles_alive;
sub excludes_roles {
    map {
        my $role = MyRole::Excluder->meta->generate_role(
            parameters => {
                exclude => $_,
            },
        );
        push @keep_roles_alive, $role;
        $role->name;
    } @_
}

lives_ok {
    Moose::Meta::Class->create_anon_class(
        roles => [ excludes_roles('Role::A') ],
    );
};

throws_ok {
    Moose::Meta::Class->create_anon_class(
        roles => [ 'Role::A', excludes_roles('Role::A') ],
    );
} qr/^Conflict detected: Role Moose::Meta::Role::__ANON__::SERIAL::\d+ excludes role 'Role::A'/;

lives_ok {
    Moose::Meta::Class->create_anon_class(
        roles => [ 'Role::B', excludes_roles('Role::A') ],
    );
};

