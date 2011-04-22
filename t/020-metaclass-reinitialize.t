#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

BEGIN {
    require Moose;
    if (Moose->VERSION < 1.9900) {
        plan skip_all => "this test isn't relevant on Moose 1.x";
    }
}

{
    package Foo::Meta::Role::Attribute;
    use Moose::Role;

    has foo => (is => 'ro');
}

{
    package Foo::Exporter;
    use Moose::Exporter;
    Moose::Exporter->setup_import_methods(
        role_metaroles => {
            applied_attribute => ['Foo::Meta::Role::Attribute'],
        },
    );
}

{
    package Foo::Role;
    use MooseX::Role::Parameterized;

    role {
        my $p = shift;
        my %args = @_;
        Foo::Exporter->import({into => $args{operating_on}->name});

        has foo => (is => 'ro', foo => 'bar');
    };
}

{
    package Foo;
    use Moose;
    with 'Foo::Role';
}

{
    is(Foo->meta->find_attribute_by_name('foo')->foo, 'bar',
       "applied_attribute metaroles work");
}

done_testing;

