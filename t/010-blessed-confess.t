#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;

do {
    package MyRole;
    use MooseX::Role::Parameterized;
    ::is(\&confess, \&Carp::confess, 'confess');
    ::is(\&blessed, \&Scalar::Util::blessed, 'blessed');
};

