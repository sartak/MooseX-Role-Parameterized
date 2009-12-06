use strict;
use warnings;
use Test::More;
use Test::Exception;

use FindBin;
use lib "$FindBin::Bin/lib";

{
    package Foo;
    use MooseX::Role::Parameterized;

    role {
        with 'Bar', { bar => 'params' };
    };
}

{
    package Moo;
    use Moose;
    ::lives_ok(sub {
        with 'Foo';
    });
}

done_testing;
