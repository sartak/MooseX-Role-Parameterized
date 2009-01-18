#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;

do {
    package MyRole;
    use MooseX::Role::Parameterized;

    parameter attribute => (
        isa => 'Str',
    );

    sub meth { 1 }

    role {
        my $p = shift;

        has $p->attribute => (
            is => 'ro',
        );
    };
};

do {
    package MyClass;
    use Moose;
    with 'MyRole' => {
        attribute => 'attr',
    };
};

ok(MyClass->can('attr'), "the parameterized attribute was composed");
ok(MyClass->can('meth'), "the unparameterized method was composed");

