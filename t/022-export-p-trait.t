#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

BEGIN {
    package MyTrait::Label;
    use MooseX::Role::Parameterized;

    parameter default => (
        is  => 'rw',
        isa => 'Str',
    );

    role {
        my $p = shift;

        has label => (
            is      => 'rw',
            isa     => 'Str',
            default => $p->default,
        );
    };
};

BEGIN {
    package t::MooseX::LabeledAttributes;
    use Moose::Exporter;
    $INC{'t/MooseX/LabeledAttributes.pm'} = 1;

    Moose::Exporter->setup_import_methods(
        class_metaroles => {
            attribute => [ 'MyTrait::Label' => { default => 'no label' } ],
        },
    );
}

do {
    package MyClass::LabeledURL;
    use Moose;
    use t::MooseX::LabeledAttributes;

    has name => (
        is => 'ro',
    );

    has url => (
        is    => 'ro',
        label => 'overridden',
    );

    no Moose;
    no t::MooseX::LabeledAttributes;
};

my $meta = MyClass::LabeledURL->meta;
is($meta->get_attribute('name')->label, 'no label');
is($meta->get_attribute('url')->label, 'overridden');

done_testing;
