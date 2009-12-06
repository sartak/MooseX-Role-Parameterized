package Bar;

use MooseX::Role::Parameterized;

parameter baz => (
    isa     => 'Str',
    default => 'moo',
);

role {
};

1;
