#!/usr/bin/env perl
use strict;
use warnings;
use Test::More skip_all => "not implemented yet";

do {
    package YAPC;
    use MooseX::Role::Parameterized;

    parameter organizer => (
        isa      => 'Str',
        required => 1,
    );

    parameter location => (
        isa      => 'Str',
        required => 1,
    );

    role {
        my $p = shift;

        method describe => sub {
            return sprintf 'organized by %s in %s',
                $p->organizer,
                $p->location;
        };
    };
};

do {
    package YAPC::Asia;
    use MooseX::Role::Parameterized;

    # This can't work sanely; if you want the role to be parameterized you need
    # to declare it as such
#    use Moose::Role;

    with 'YAPC' => {
        location => 'Tokyo',
    };
};

