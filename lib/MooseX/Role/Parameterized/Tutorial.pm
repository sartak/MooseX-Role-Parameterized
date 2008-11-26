package MooseX::Role::Parameterized::Tutorial;
confess "Don't use this module, read it!";

__END__

=head1 NAME

MooseX::Role::Parameterized::Tutorial - why and how

=head1 ROLES

Roles are composable units of behavior. See L<Moose::Cookbook::Roles::Recipe1>
for an introduction to L<Moose::Role>.

=head1 MOTIVATION

Roles are exceedingly useful. While combining roles affords you a great deal of
flexibility, individual roles have very little in the way of configurability.
Core Moose provides C<alias> for renaming methods to avoid conflicts, and
C<excludes> for ignoring methods you don't want or need (see
L<Moose::Cookbook::Roles::Recipe2> for more about C<alias> and C<excludes>).


=head1 USAGE

=head3 C<with>

=head3 C<parameter>

=head3 C<role>

=head1 IMPLEMENTATION NOTES

=head1 USES

Ideally these will become fully-explained examples in something resembling
L<Moose::Cookbook>. But for now, only a braindump.

=over 4

=item Configure a role's attributes

You can rename methods with core Moose, but now you can rename attributes. You
can now also choose type, default value, whether it's required, B<traits>, etc.

    parameter traits => (
        is      => 'ro',
        isa     => 'ArrayRef[Str]',
        default => sub { [] },
    );

    has action => (
        traits => $p->traits,
        ...
    );

=item Inform a role of your class' attributes and methods

Core roles can require only methods with specific names. Now your roles can
require that you specify a method name you wish the role to instrument, or
which attributes to dump to a file.

    parameter instrument_method => (
        is       => 'ro',
        isa      => 'Str',
        required => 1,
    );

    around $p->instrument_method => sub { ... };

=item Arbitrary execution choices

Your role may be able to provide configuration in how the role's methods
operate. For example, you can tell the role whether to save intermediate
states.

    parameter save_intermediate => (
        is      => 'ro',
        isa     => 'Bool',
        default => 0,
    );

    method process => sub {
        ...
        if ($p->save_intermediate) { ... }
        ...
    };

=item Deciding a backend

Your role may be able to freeze and thaw your instances using L<YAML>, L<JSON>,
L<Storable>. Which backend to use can be a parameter.

    parameter format => (
        is => 'ro',
        isa => (enum ['Storable', 'YAML', 'JSON']),
        default => 'Storable',
    );

    if ($p->format eq 'Storable') {
        method freeze => sub { ... };
        method thaw   => sub { ... };
    }
    elsif ($p->format eq 'YAML') ...
    ...

=back

=cut

