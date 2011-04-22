#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Fatal;

do {
    package MyRole::Storage;
    use MooseX::Role::Parameterized;

    ::like( ::exception {
        parameter()
    }, qr/^You must provide a name for the parameter/);

    role {
        ::like( ::exception {
            extends 'MyRole::Parameterized';
        }, qr/^Roles do not currently support 'extends'/);
        ::like( ::exception {
            inner()
        }, qr/^Roles cannot support 'inner'/);
        ::like( ::exception {
            augment()
        }, qr/^Roles cannot support 'augment'/);
        ::like( ::exception {
            parameter()
        }, qr/^'parameter' may not be used inside of the role block/);
    };
};

Moose::Meta::Class->create_anon_class(
    roles => ['MyRole::Storage'],
);

done_testing;

