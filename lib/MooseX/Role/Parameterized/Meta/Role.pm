#!/usr/bin/env perl
package MooseX::Role::Parameterized::Meta::Role;
use Moose;
extends 'Moose::Meta::Role';

use MooseX::Role::Parameterized::Parameters;

sub parameter_class { 'MooseX::Role::Parameterized::Parameters' }

__PACKAGE__->meta->make_immutable;
no Moose;

1;

