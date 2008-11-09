#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 1;
use MooseX::Role::Parameterized::Parameters;

my $p = MooseX::Role::Parameterized::Parameters->new;
can_ok($p => 'meta');

