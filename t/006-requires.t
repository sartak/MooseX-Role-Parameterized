#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 5;
use Test::Fatal;

do {
    package MyRole::Requires;
    use MooseX::Role::Parameterized;

    parameter requires => (
        is  => 'rw',
        isa => 'Str',
    );

    role {
        my $p = shift;
        requires $p->requires;
    };
};

my @keep_roles_alive;
sub requires_names {
    map {
        my $role = MyRole::Requires->meta->generate_role(
            parameters => {
                requires => $_,
            },
        );
        push @keep_roles_alive, $role;
        $role->name;
    } @_
}

like( exception {
    Moose::Meta::Class->create_anon_class(
        roles => [ requires_names('alpha') ],
    );
}, qr/'Moose::Meta::Role::__ANON__::SERIAL::\d+' requires the method 'alpha' to be implemented by 'Class::MOP::Class::__ANON__::SERIAL::\d+'/);

is (exception {
    Moose::Meta::Class->create_anon_class(
        methods => {
            alpha => sub {},
        },
        roles => [ requires_names('alpha') ],
    );
}, undef);

like( exception {
    Moose::Meta::Class->create_anon_class(
        methods => {
            alpha => sub {},
        },
        roles => [ requires_names('alpha', 'beta') ],
    );
}, qr/'Moose::Meta::Role::__ANON__::SERIAL::\d+\|Moose::Meta::Role::__ANON__::SERIAL::\d+' requires the method 'beta' to be implemented by 'Class::MOP::Class::__ANON__::SERIAL::\d+'/);

like( exception {
    Moose::Meta::Class->create_anon_class(
        methods => {
            beta => sub {},
        },
        roles => [ requires_names('alpha', 'beta') ],
    );
}, qr/'Moose::Meta::Role::__ANON__::SERIAL::\d+\|Moose::Meta::Role::__ANON__::SERIAL::\d+' requires the method 'alpha' to be implemented by 'Class::MOP::Class::__ANON__::SERIAL::\d+'/);

is (exception {
    Moose::Meta::Class->create_anon_class(
        methods => {
            alpha => sub {},
            beta => sub {},
        },
        roles => [ requires_names('alpha', 'beta') ],
    );
}, undef);

