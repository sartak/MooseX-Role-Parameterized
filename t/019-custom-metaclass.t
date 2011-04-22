#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Moose;

do {
    package MyTrait;
    use Moose::Role;
};

BEGIN {
    do {
        package Parameterized;
        use Moose;
        extends 'Moose::Meta::Role';
        with 'MooseX::Role::Parameterized::Meta::Trait::Parameterized';
        with 'MyTrait';
    };

    do {
        package Parameterizable;
        use Moose;
        extends 'MooseX::Role::Parameterized::Meta::Role::Parameterizable';
        sub parameterized_role_metaclass { 'Parameterized' }
    };
}

do {
    package MyRole;
    use MooseX::Role::Parameterized -metaclass => 'Parameterizable';

    role {
        my ($params, %extra) = @_;
        ::does_ok($extra{operating_on}, 'MyTrait', 'parameterized role should do the MyTrait trait');
    }
};

do {
    package MyClass;
    use Moose;
    with 'MyRole';
};

MyClass->new;

done_testing;

