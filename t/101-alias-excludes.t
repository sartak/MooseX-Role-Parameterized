#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Fatal;

do {
    package MyRole;
    use MooseX::Role::Parameterized;

    ::like( ::exception {
        parameter 'alias';
    }, qr/^The parameter name \(alias\) is currently forbidden/);

    ::like( ::exception {
        parameter 'excludes';
    }, qr/^The parameter name \(excludes\) is currently forbidden/);
};

do {
    package MyClass;
    use Moose;

    ::like( ::exception {
        with MyRole => {
            alias => 1,
        };
    }, qr/^The parameter name \(alias\) is currently forbidden/);

    ::like( ::exception {
        with MyRole => {
            excludes => 1,
        };
    }, qr/^The parameter name \(excludes\) is currently forbidden/);
};

do {
    package OrdinaryRole;
    use MooseX::Role::Parameterized;

    sub code { 'originally code' }

    sub other_code { 'originally other_code' }

    role { }
};

do {
    package OrdinaryClass;
    use Moose;

    with OrdinaryRole => {
        -alias    => { code => 'new_code' },
        -excludes => [ 'other_code' ],
    };
};

ok(!OrdinaryClass->can('other_code'));
is(OrdinaryClass->code, 'originally code');
is(OrdinaryClass->new_code, 'originally code');

done_testing;

