#!/usr/bin/env perl
package MooseX::Role::Parameterized;
use strict;
use warnings;
use MooseX::Role::Parameterized::Meta::Role;

use Moose::Role ();
use Moose::Exporter;

Moose::Exporter->setup_import_methods;

sub init_meta {
    my $self = shift;

    return Moose::Role->init_meta(@_,
        metaclass => 'MooseX::Role::Parameterized::Meta::Role',
    );
}

1;

