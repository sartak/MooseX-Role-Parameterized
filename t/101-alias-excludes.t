#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 4;
use Test::Exception;

do {
    package MyRole;
    use MooseX::Role::Parameterized;

    ::throws_ok {
        parameter 'alias';
    } qr/^The parameter name \(alias\) is currently forbidden/;

    ::throws_ok {
        parameter 'excludes';
    } qr/^The parameter name \(excludes\) is currently forbidden/;
};

do {
    package MyClass;
    use MooseX::Role::Parameterized;

    ::throws_ok {
        with MyRole => {
            alias => 1,
        };
    } qr/^The parameter name \(alias\) is currently forbidden/;

    ::throws_ok {
        with MyRole => {
            excludes => 1,
        };
    } qr/^The parameter name \(excludes\) is currently forbidden/;
};

