#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;
use Test::Exception;

my ($parameters, %args);

do {
    package MyRole;
    use MooseX::Role::Parameterized;

    parameter length => (
        is       => 'rw',
        isa      => 'Int',
        required => 1,
    );

    role {
        ($parameters, %args) = @_;
    };
};

ok(MyRole->meta->has_role_generator, "MyRole has a role generator");

my $role = MyRole->meta->generate_role(
    length => 7,
);

isa_ok($role, 'Moose::Meta::Role', 'generate_role created a role');

is($parameters->length, 7);

