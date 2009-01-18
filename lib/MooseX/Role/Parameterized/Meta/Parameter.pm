package MooseX::Role::Parameterized::Meta::Parameter;
use Moose;
extends 'Moose::Meta::Attribute';


__PACKAGE__->meta->make_immutable(
    inline_constructor => 1,
    constructor_name   => "_new",
);
no Moose;

1;

