package MooseX::Role::Parameterized::Meta::Parameter;
use Moose;
extends 'Moose::Meta::Attribute';

our $VERSION = '0.25';

# This doesn't actually do anything because _process_options does not consult
# the default value of "is". hrm.
has '+is' => (
    default => 'ro',
);

around _process_options => sub {
    my $orig = shift;
    my ($class, $name, $options) = @_;

    $options->{is} ||= 'ro';

    $orig->(@_);
};

__PACKAGE__->meta->make_immutable(
    inline_constructor => 1,
    replace_constructor => 1,
    constructor_name   => "_new",
);
no Moose;

1;

__END__

=head1 NAME

MooseX::Role::Parameterized::Meta::Parameter - metaclass for parameters

=head1 DESCRIPTION

This is the metaclass for parameter objects, a subclass of
L<Moose::Meta::Attribute>. Its sole purpose is to make the default value
of the C<is> option C<ro>.

=cut

