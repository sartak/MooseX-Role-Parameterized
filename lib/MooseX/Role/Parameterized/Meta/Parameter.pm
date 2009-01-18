package MooseX::Role::Parameterized::Meta::Parameter;
use Moose;
extends 'Moose::Meta::Attribute';

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
    constructor_name   => "_new",
);
no Moose;

1;

