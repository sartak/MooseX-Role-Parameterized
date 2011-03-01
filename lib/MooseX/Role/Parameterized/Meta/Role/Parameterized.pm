package MooseX::Role::Parameterized::Meta::Role::Parameterized;
use Moose;
extends 'Moose::Meta::Role';
with 'MooseX::Role::Parameterized::Meta::Trait::Parameterized';

our $VERSION = '0.24';

around reinitialize => sub {
    my $orig = shift;
    my $class = shift;
    my ($pkg) = @_;
    my $meta = blessed($pkg) ? $pkg : Class::MOP::class_of($pkg);

    # this bit is possibly subject to change. I've lodged complaints with the
    # appropriate Moose developers :)
    my $genitor    = $meta->genitor;
    my $parameters = $meta->parameters;

    my $new = $class->$orig(
        @_,
        (defined($genitor)    ? (genitor    => $genitor)    : ()),
        (defined($parameters) ? (parameters => $parameters) : ()),
    );

    # in case the role metaclass was reinitialized
    $MooseX::Role::Parameterized::CURRENT_METACLASS = $new;
    return $new;
};

__PACKAGE__->meta->make_immutable;
no Moose;

1;

__END__

=head1 NAME

MooseX::Role::Parameterized::Meta::Role::Parameterized - metaclass for parameterized roles

=head1 DESCRIPTION

This is the metaclass for parameterized roles; that is, parameterizable roles
with their parameters bound. See
L<MooseX::Role::Parameterized::Meta::Trait::Parameterized> which has all the guts.

=cut

