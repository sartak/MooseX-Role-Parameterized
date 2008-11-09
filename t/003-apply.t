#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 1;
use Test::Exception;

do {
    package MyRole::Storage;
    use MooseX::Role::Parameterized;
    use Moose::Util::TypeConstraints;

    parameter format => (
        is       => 'ro',
        isa      => (enum ['Dumper', 'Storable']),
        required => 1,
    );

    parameter freeze_method => (
        is      => 'ro',
        isa     => 'Str',
        lazy    => 1,
        default => sub { "freeze_" . shift->format },
    );

    parameter thaw_method => (
        is      => 'ro',
        isa     => 'Str',
        lazy    => 1,
        default => sub { "thaw_" . shift->format },
    );

    role {
        my $p = shift;
        my $format = $p->format;

        my ($freezer, $thawer);

        if ($format eq 'Dumper') {
            require Data::Dumper;
            $freezer = \&Data::Dumper::Dumper;
            $thawer  = sub { eval "@_" };

        }
        elsif ($format eq 'Storable') {
            require Storable;
            $freezer = \&Storable::nfreeze;
            $thawer  = \&Storable::thaw;
        }
        else {
            die "Unknown format ($format)";
        }

        method $p->freeze_method => $freezer;
        method $p->thaw_method   => $thawer;
    };
};

throws_ok {
    package MyClass::Error;
    use Moose;
    with 'MyRole::Storage';
} qr/^Attribute \(format\) is required/;

do {
    package MyClass::Dumper;
    use Moose;
    with 'MyRole::Storage' => {
        format => 'Dumper',
    };
};

