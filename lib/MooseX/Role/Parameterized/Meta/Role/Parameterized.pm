#!/usr/bin/env perl
package MooseX::Role::Parameterized::Meta::Role::Parameterized;
use Moose;
extends 'Moose::Meta::Role';

has parameters => (
    is       => 'rw',
    isa      => 'MooseX::Role::Parameterized::Parameters',
    required => 1,
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

