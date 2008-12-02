package MooseX::Role::Parameterized;

use Moose (
    extends => { -as => 'moose_extends' },
    around  => { -as => 'moose_around' },
    qw/confess blessed/,
);

use Carp 'croak';
use Moose::Role ();
moose_extends 'Moose::Exporter';

use MooseX::Role::Parameterized::Meta::Role::Parameterizable;

our $CURRENT_METACLASS;

__PACKAGE__->setup_import_methods(
    with_caller => ['parameter', 'role', 'method'],
    as_is       => [
        'has', 'with', 'extends', 'requires', 'excludes', 'augment', 'inner',
        'before', 'after', 'around', 'super', 'override', 'confess',
        'blessed',
    ],
);

sub parameter {
    my $caller = shift;
    my $names  = shift;

    $names = [$names] if !ref($names);

    for my $name (@$names) {
        Class::MOP::Class->initialize($caller)->add_parameter($name, @_);
    }
}

sub role {
    my $caller         = shift;
    my $role_generator = shift;
    Class::MOP::Class->initialize($caller)->role_generator($role_generator);
}

sub init_meta {
    my $self = shift;

    return Moose::Role->init_meta(@_,
        metaclass => 'MooseX::Role::Parameterized::Meta::Role::Parameterizable',
    );
}

# give role a (&) prototype
moose_around _make_wrapper => sub {
    my $orig = shift;
    my ($self, $caller, $sub, $fq_name) = @_;

    if ($fq_name =~ /::role$/) {
        return sub (&) { $sub->($caller, @_) };
    }

    return $orig->(@_);
};

sub has {
    confess "has must be called within the role { ... } block."
        unless $CURRENT_METACLASS;

    my $names = shift;
    $names = [$names] if !ref($names);

    for my $name (@$names) {
        $CURRENT_METACLASS->add_attribute($name, @_);
    }
}

sub method {
    confess "method must be called within the role { ... } block."
        unless $CURRENT_METACLASS;

    my $caller = shift;
    my $name   = shift;
    my $body   = shift;

    my $method = $CURRENT_METACLASS->method_metaclass->wrap(
        package_name => $caller,
        name         => $name,
        body         => $body,
    );

    $CURRENT_METACLASS->add_method($name => $method);
}

sub before {
    confess "before must be called within the role { ... } block."
        unless $CURRENT_METACLASS;

    my $code = pop @_;

    for (@_) {
        croak "Roles do not currently support "
            . ref($_)
            . " references for before method modifiers"
            if ref $_;
        $CURRENT_METACLASS->add_before_method_modifier($_, $code);
    }
}

sub after {
    confess "after must be called within the role { ... } block."
        unless $CURRENT_METACLASS;

    my $code = pop @_;

    for (@_) {
        croak "Roles do not currently support "
            . ref($_)
            . " references for after method modifiers"
            if ref $_;
        $CURRENT_METACLASS->add_after_method_modifier($_, $code);
    }
}

sub around {
    confess "around must be called within the role { ... } block."
        unless $CURRENT_METACLASS;

    my $code = pop @_;

    for (@_) {
        croak "Roles do not currently support "
            . ref($_)
            . " references for around method modifiers"
            if ref $_;
        $CURRENT_METACLASS->add_around_method_modifier($_, $code);
    }
}

sub with {
    confess "with must be called within the role { ... } block."
        unless $CURRENT_METACLASS;
    Moose::Util::apply_all_roles($CURRENT_METACLASS, @_);
}

sub requires {
    confess "requires must be called within the role { ... } block."
        unless $CURRENT_METACLASS;
    croak "Must specify at least one method" unless @_;
    $CURRENT_METACLASS->add_required_methods(@_);
}

sub excludes {
    confess "excludes must be called within the role { ... } block."
        unless $CURRENT_METACLASS;
    croak "Must specify at least one role" unless @_;
    $CURRENT_METACLASS->add_excluded_roles(@_);
}

# see Moose.pm for discussion
sub super {
    return unless $Moose::SUPER_BODY;
    $Moose::SUPER_BODY->(@Moose::SUPER_ARGS);
}

sub override {
    confess "override must be called within the role { ... } block."
        unless $CURRENT_METACLASS;

    my ($name, $code) = @_;
    $CURRENT_METACLASS->add_override_method_modifier($name, $code);
}

sub extends { croak "Roles do not currently support 'extends'" }

sub inner { croak "Roles cannot support 'inner'" }

sub augment { croak "Roles cannot support 'augment'" }

1;

__END__

=head1 NAME

MooseX::Role::Parameterized - parameterized roles

=head1 SYNOPSIS

    package MyRole::Counter;
    use MooseX::Role::Parameterized;

    parameter name => (
        is       => 'ro',
        isa      => 'Str',
        required => 1,
    );

    role {
        my $p = shift;

        my $name = $p->name;

        has $name => (
            is      => 'rw',
            isa     => 'Int',
            default => 0,
        );

        method "increment_$name" => sub {
            my $self = shift;
            $self->$name($self->$name + 1);
        };

        method "decrement_$name" => sub {
            my $self = shift;
            $self->$name($self->$name - 1);
        };
    };

    package MyGame::Tile;
    use Moose;

    with 'MyRole::Counter' => { name => 'stepped_on' };

=head1 L<MooseX::Role::Parameterized::Tutorial>

B<Stop!> If you're new here, please read
L<MooseX::Role::Parameterized::Tutorial>.

=head1 DESCRIPTION

Your parameterized role consists of two things: parameter declarations and a
C<role> block.

Parameters are declared using the L</parameter> keyword which very much
resembles L<Moose/has>. You can use any option that L<Moose/has> accepts.
These parameters will get their values when the consuming class (or role) uses
L<Moose/with>. A parameter object will be constructed with these values, and
passed to the C<role> block.

The C<role> block then uses the usual L<Moose::Role> keywords to build up a
role. You can shift off the parameter object to inspect what the consuming
class provided as parameters. You can use the parameters to make your role
customizable!

There are many paths to parameterized roles (hopefully with a consistent enough
API); I believe this to be the easiest and most flexible implementation.
Coincidentally, Pugs has a very similar design (I'm not yet convinced that that
is a good thing).

=head1 CAVEATS

You must use this syntax to declare methods in the role block:
C<method NAME => sub { ... };>. This is due to a limitation in Perl. In return
though you can use parameters I<in your methods>!

You must use all the keywords in the role block. If it turns out to be correct,
we'll compose the parameterizable role (everything outside the role block) with
the parameterized role (everything inside the role block). We throw an error if
you try to use a keyword outside of the role block, so don't worry about it for
now.

L<Moose::Role/alias> and L<Moose::Role/excludes> are not yet supported. I'm
completely unsure of whether they should be handled by this module. Until we
figure out a plan, both declaring and providing a parameter named C<alias> or
C<excludes> is an error.

=head1 AUTHOR

Shawn M Moore, C<< <sartak@bestpractical.com> >>

=cut

