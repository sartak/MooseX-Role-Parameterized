#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 12;
use Test::Exception;

use MooseX::Role::Parameterized::Parameters;

my $p = MooseX::Role::Parameterized::Parameters->new;
can_ok($p => 'meta');

do {
    package MyRole::NoParameters;
    use MooseX::Role::Parameterized;
};

my $parameter_metaclass = MyRole::NoParameters->meta->parameter_metaclass;
is($parameter_metaclass->get_all_attributes, 0, "no parameters");

do {
    package MyRole::LengthParameter;
    use MooseX::Role::Parameterized;

    parameter length => (
        is       => 'ro',
        isa      => 'Int',
        required => 1,
    );
};

$parameter_metaclass = MyRole::LengthParameter->meta->parameter_metaclass;
is($parameter_metaclass->get_all_attributes, 1, "exactly one parameter");

my $parameter = ($parameter_metaclass->get_all_attributes)[0];
is($parameter->name, 'length', "parameter name");
ok($parameter->is_required, "parameter is required");

throws_ok {
    MyRole::LengthParameter->meta->construct_parameters;
} qr/^Attribute \(length\) is required/;

$p = MyRole::LengthParameter->meta->construct_parameters(
    length => 5,
);

is($p->length, 5, "correct length");

do {
    package MyRole::LengthParameter;
    use MooseX::Role::Parameterized;

    parameter ['first_name', 'last_name'] => (
        is  => 'rw',
        isa => 'Str',
    );
};

$parameter_metaclass = MyRole::LengthParameter->meta->parameter_metaclass;
is($parameter_metaclass->get_all_attributes, 3, "three parameters");

for my $param_name ('first_name', 'last_name') {
    my $param = $parameter_metaclass->get_attribute($param_name);
    is($param->type_constraint, 'Str', "$param_name type constraint");
    ok(!$param->is_required, "$param_name is optional");
}

