#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 6;
use Test::Exception;

do {
    package MyCompositeRoleA;
    use MooseX::Role::Parameterized;

    parameter attribute => (
        isa => 'Str',
        required => 1,
    );

    role {
        my $p = shift;

        has $p->attribute => (
            is => 'Int',
        );
    };
};

do {
    package MyCompositeRoleB;
    use MooseX::Role::Parameterized;

    parameter accessor => (
        isa => 'Str',
        required => 1,
    );

    role {
        my $p = shift;

        has $p->accessor => (
            is => 'rw',
            isa => 'Int',
        );
    };
};

do {
    package MyDoubleConsumer;
    use Moose;
    with MyCompositeRoleA => { attribute => 'foo' },
         MyCompositeRoleB => { accessor  => 'bar' };
};

TODO: {
    local $TODO = "role-role application for parameterized roles doesn't work yet";
    ok(MyDoubleConsumer->can('foo'), 'first role in composite applied successfully');
    ok(MyDoubleConsumer->can('bar'), 'second role in composite applied successfully');
};

do {
    package MyExtendingRole;
    use MooseX::Role::Parameterized;

    parameter foo => (
        isa => 'Int',
    );

    role {
        my $p = shift;

        with 'MyCompositeRoleA', { attribute => 'bar' };

        has foo => (
            is => 'rw',
            default => sub { $p->foo },
        );
    };
};

do {
    package MyExtendedConsumer;
    use Moose;
    with MyCompositeRoleA => { attribute => 'bar' },
         MyExtendingRole  => { foo => 23 };
};

TODO: {
    local $TODO = "role-role application for parameterized roles doesn't work yet";
    ok(MyExtendedConsumer->can('bar'), 'role composed through other role applied successfully');
    is(eval { MyExtendedConsumer->new->foo }, 23, 'role composing other role applied successfully');
};;

do {
    package MyRoleProxy;
    use MooseX::Role::Parameterized;

    parameter rolename   => (isa => "Str");
    parameter roleparams => (isa => "HashRef");

    role {
        my $p = shift;

        with $p->rolename, $p->roleparams;
    };
};

do {
    package MyProxyConsumer;
    use Moose;
    with(
        MyRoleProxy => { 
            rolename   => 'MyCompositeRoleA',
            roleparams => { attribute => 'baz' },
        },
        MyCompositeRoleB => {
            accessor => 'qux',
        },
    );
};

TODO: {
    local $TODO = "role-role application for parameterized roles doesn't work yet";
    ok(MyProxyConsumer->can('baz'), 'proxied role got applied successfully');
    ok(MyProxyConsumer->can('qux'), 'other role besides proxied one got applied successfully');
};

