#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 15;
use Test::Exception;

do {
    package MyRole::Storage;
    use MooseX::Role::Parameterized;
    use Moose::Util::TypeConstraints;

    parameter format => (
        isa      => (enum ['Dumper', 'Storable']),
        required => 1,
    );

    parameter freeze_method => (
        isa     => 'Str',
        lazy    => 1,
        default => sub { "freeze_" . shift->format },
    );

    parameter thaw_method => (
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

do {
    package MyClass::Dumper;
    use Moose;
    with 'MyRole::Storage' => {
        format => 'Dumper',
    };
};

can_ok('MyClass::Dumper' => qw(freeze_Dumper thaw_Dumper));
cant_ok('MyClass::Dumper' => qw(freeze_Storable thaw_Storable));

do {
    package MyClass::Storable;
    use Moose;
    with 'MyRole::Storage' => {
        format => 'Storable',
    };
};

can_ok('MyClass::Storable' => qw(freeze_Storable thaw_Storable));
cant_ok('MyClass::Storable' => qw(freeze_Dumper thaw_Dumper));

do {
    package MyClass::DumperRenamed;
    use Moose;
    with 'MyRole::Storage' => {
        format => 'Dumper',
        freeze_method => 'save',
        thaw_method   => 'load',
    };
};

can_ok('MyClass::DumperRenamed' => qw(save load));
cant_ok('MyClass::DumperRenamed' => qw(freeze_Dumper freeze_Storable thaw_Dumper thaw_Storable));

do {
    package MyClass::Both;
    use Moose;
    with 'MyRole::Storage' => { format => 'Dumper'   };
    with 'MyRole::Storage' => { format => 'Storable' };
};

can_ok('MyClass::Both' => qw(freeze_Dumper freeze_Storable thaw_Dumper thaw_Storable));

do {
    package MyClass::Three;
    use Moose;
    with 'MyRole::Storage' => { format => 'Dumper'   };
    with 'MyRole::Storage' => { format => 'Storable' };
    with 'MyRole::Storage' => {
        format        => 'Storable',
        freeze_method => 'store',
        thaw_method   => 'dump',
    };
};

can_ok('MyClass::Three' => qw(freeze_Dumper freeze_Storable thaw_Dumper thaw_Storable store dump));

throws_ok {
    package MyClass::Error::Required;
    use Moose;
    with 'MyRole::Storage';
} qr/^Attribute \(format\) is required/;

throws_ok {
    package MyClass::Error::Invalid;
    use Moose;
    with 'MyRole::Storage' => {
        format => 'YAML',
    };
} qr/^Attribute \(format\) does not pass the type constraint/;

sub cant_ok {
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my $instance = shift;
    for my $method (@_) {
        ok(!$instance->can($method), "$instance cannot $method");
    }
}

