#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 1;
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

sub excludes_roles {
    map {
        MyRole::Excluder->meta->generate_role(exclude => $_)->name
    } @_
}

TODO: {
    local $TODO = "the error message says Role::A excludes Role::A..??!";
    throws_ok {
        Moose::Meta::Class->create_anon_class(
            roles => [ 'Role::A', excludes_roles('Role::A') ],
        );
    } qr/^Conflict detected: Moose::Meta::Role::__ANON__::SERIAL::\d+ excludes role 'Role::A'/;
};

#lives_ok {
#    Moose::Meta::Class->create_anon_class(
#        methods => {
#            alpha => sub {},
#        },
#        roles => [ requires_names('alpha') ],
#    );
#};
#
#throws_ok {
#    Moose::Meta::Class->create_anon_class(
#        methods => {
#            alpha => sub {},
#        },
#        roles => [ requires_names('alpha', 'beta') ],
#    );
#} qr/'Moose::Meta::Role::__ANON__::SERIAL::\d+\|Moose::Meta::Role::__ANON__::SERIAL::\d+' requires the method 'beta' to be implemented by 'Class::MOP::Class::__ANON__::SERIAL::\d+'/;
#
#throws_ok {
#    Moose::Meta::Class->create_anon_class(
#        methods => {
#            beta => sub {},
#        },
#        roles => [ requires_names('alpha', 'beta') ],
#    );
#} qr/'Moose::Meta::Role::__ANON__::SERIAL::\d+\|Moose::Meta::Role::__ANON__::SERIAL::\d+' requires the method 'alpha' to be implemented by 'Class::MOP::Class::__ANON__::SERIAL::\d+'/;
#
#lives_ok {
#    Moose::Meta::Class->create_anon_class(
#        methods => {
#            alpha => sub {},
#            beta => sub {},
#        },
#        roles => [ requires_names('alpha', 'beta') ],
#    );
#};
#
