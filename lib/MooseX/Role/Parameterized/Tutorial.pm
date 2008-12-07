package MooseX::Role::Parameterized::Tutorial;
confess "Don't use this module, read it!";

__END__

=head1 NAME

MooseX::Role::Parameterized::Tutorial - why and how

=head1 MOTIVATION

Roles are composable units of behavior. They are useful for factoring out
functionality common to many classes from any part of your class hierarchy.See
L<Moose::Cookbook::Roles::Recipe1> for an introduction to L<Moose::Role>.

While combining roles affords you a great deal of flexibility, individual roles
have very little in the way of configurability.  Core Moose provides C<alias>
for renaming methods to avoid conflicts, and C<excludes> for ignoring methods
you don't want or need (see L<Moose::Cookbook::Roles::Recipe2> for more
about C<alias> and C<excludes>).

Because roles serve many different masters, they usually provide only the least
common denominator of functionality. Not all consumers of a role have a C<>.
Thus, more configurability than C<alias> and C<excludes> is required. Perhaps
your role needs to know which method to call when it is done. Or what default
value to use for its url attribute.

Parameterized roles offer exactly this solution.

=head1 USAGE

=head3 C<with>

The syntax of a class consuming a parameterized role has not changed from the
standard C<with>. You pass in parameters just like you pass in C<alias> and
C<excludes> to ordinary roles:

    with 'MyRole::InstrumentMethod' => {
        method_name => 'dbh_do',
        log_to      => 'query.log',
    };

=head3 C<parameter>

Inside your parameterized role, you specify a set of parameters. This is
exactly like specifying the attributes of a class. Instead of C<has> you use
the keyword C<parameter>, but your parameters can use any options to C<has>.

    parameter 'delegation' => (
        is        => 'ro',
        isa       => 'HashRef|ArrayRef|RegexpRef',
        predicate => 'has_delegation',
    );

Behind the scenes, C<parameter> uses C<has> to add attributes to a parameter
class. The arguments to C<with> are used to construct a parameter object, which
has the attributes specified by calls to C<parameter>. The parameter object is
then passed to...

=head3 C<role>

C<role> takes a block of code that will be used to generate your role with its
parameters bound. Here is where you declare parameterized components: use
C<has>, method modifiers, and so on. You receive as an argument the parameter
object constructed by C<with>. You can access the parameters just like regular
attributes on that object (assuming you declared them readable).

Each time you compose this parameterized role, the role {} block will be
executed. It will receive a new parameter object and produce an entirely new
role.

Due to limitations inherent in Perl, you must declare methods with
C<method name => sub { ... }> instead of the usual C<sub name { ... }>. Your
methods may, of course, close over the parameter object. This means that your
methods may use parameters however they wish!

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

