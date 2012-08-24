#!/usr/bin/env perl
use strict;
use warnings;
use Test::More skip_all => "Not implemented yet";

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

    # what is the secret sauce?
}

do {
    package MyClass::LabeledURL;
    use Moose;
    use t::MooseX::LabeledAttributes default => 'no label';

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

do {
    package MyClass::LabeledPost;
    use Moose;
    use t::MooseX::LabeledAttributes default => 'TODO!';

    has name => (
        is => 'ro',
    );

    has body => (
        is    => 'ro',
        label => 'nevermind...',
    );

    no Moose;
    no t::MooseX::LabeledAttributes;
};

my $url_meta = MyClass::LabeledURL->meta;
is($meta->get_attribute('name')->label, 'no label');
is($meta->get_attribute('url')->label, 'overridden');

my $post_meta = MyClass::LabeledPost->meta;
is($meta->get_attribute('name')->label, 'TODO!');
is($meta->get_attribute('body')->label, 'nevermind...');

done_testing;

