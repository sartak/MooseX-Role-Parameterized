#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;
use Test::Exception;

use MooseX::Role::Parameterized::Parameters;

my $p = MooseX::Role::Parameterized::Parameters->new;
can_ok($p => 'meta');

do {
    package MyRole::NoParameters;
    use MooseX::Role::Parameterized;
};

my $parameter_class = MyRole::NoParameters->meta->parameter_class;
ok($parameter_class);

