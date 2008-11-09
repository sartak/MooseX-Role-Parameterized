#!/usr/bin/env perl
package MooseX::Role::Parameterized;
use strict;
use warnings;
use MooseX::Role::Parameterized::Meta::Role;

use Moose::Role ();
use Moose::Exporter;

Moose::Exporter->setup_import_methods(
    with_caller => ['parameter'],
);

sub parameter {
    my $caller = shift;
    $caller->meta->add_parameter(@_);
}

sub init_meta {
    my $self = shift;

    return Moose::Role->init_meta(@_,
        metaclass => 'MooseX::Role::Parameterized::Meta::Role',
    );
}

1;

