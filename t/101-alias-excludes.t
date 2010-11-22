#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 4;
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
    use MooseX::Role::Parameterized;

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

