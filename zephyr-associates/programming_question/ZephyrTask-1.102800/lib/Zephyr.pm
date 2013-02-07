
package Zephyr;
BEGIN {
  $Zephyr::VERSION = '1.102800';
}

# ABSTRACT: Top level documentation for the Zephyr homework assignment.


1;

__END__
=pod

=head1 NAME

Zephyr - Top level documentation for the Zephyr homework assignment.

=head1 VERSION

version 1.102800

=head1 DESCRIPTION

This CPAN style Perl package is intended to satisfy Zephyr's
interview problem.

There are several components in the top level directory:

=over 4

=item

The project uses Dist::Zilla to build the CPAN style distribution, it
takes care of much of the grunt work.  The file
ZephyrTask-1.102790.tar.gz is the gzipped tarball that would be
uploaded to CPAN and the ZephyrTask-1.102790 directory is the unpacked
distribution.  The files in this directory have their full POD
documentation, version numbers, tests, etc....  They would normally
*not* be checked into a source code repository, although the tarball
might be checked into a "build artifact" repository or a DPAN.

=item

The source for the package is found in the lib, and t directories and
the Dist::Zilla configuration is in the dist.ini file.  These files
are what would be checked into a repository, they are incomplete and
expect Dist::Zilla to e.g. add version numbers, reorganize POD
sections, build boilerplate tests, etc...

=back

=head1 SATISFYING THE TASK

The assignment was to "Write a component in a language or your choice
that manages the selection state (displayed/not displayed) of funds
currently shown in StyleADVISOR."  One must be able to change the
selection status of a fund, query a fund's selection status and
explicitly set a list of selected funds.  Furthermore one must support
observers of changes in the selection state.

I've created two simple classes and a role.  The C<Zephyr::App> class
is a container that holds a set of funds, identified by their unique
string id.  The C<Zephyr::Role::Selectable> role provides "selectable"
functionality to any class that consumes it, providing an
'is_selected' attribute and selected/deselected object methods.  It
also provides helper methods (add_observers, delete_observer,
observers) to maintain a list of objects that wish to be notified on
selection state changes and arranges to notify those objects when
changes occur.  The C<Zephyr::Fund> class models a fund, it has a
string valued id attribute and it consumes (does) the
C<Zephyr::Role::Selectable> role.

The test script t/demo.t demonstrates the specified functionality,
which is also illustrated in the L<Zephyr::App> synopsis.

=head1 THE TESTS

There are three types of tests in the t directory (after Dist::Zilla
processing).  All tests follow standard Perl testing practices.

=head2 BOILERPLATE TESTS

00-compile.t, release-pod-coverage.t and
release-pod-syntax.t are boilerplate tests that Dist::Zilla lets me
avoid writing, they test that every class compiles independently
(syntax is ok, all necessary "use" statements are in place, no
laziness), that all attributes and methods have documentation, and
that all of the documentation is syntactically correct, respectively.

=head2 UNIT TESTS

Each class has a unit test, built using C<Test::Class>.  They live in
the t/lib/Test subdirectory and are driven by t/run_tests.t.  They
demonstrate the use of C<Test::Class>, C<Test::Exception>,
C<Test::Deep>, and C<Test::MockObject>, along with standard Perl
testing practices.

=head2 DEMO

There is a simple demonstration test, demo.t, that addresses the
particular requirements set in the Task statement.

The demo test also sets up L<Log::Log4perl> and uses L<Test::Output>
to capture and check output generated by logging statements in the
object constructors (DEBUG level) and in the observer notification
trigger (INFO level).

=head1 THE CODE

=head2 MOOSE

The code uses C<Moose>, a widely used object system for modern Perl5,
to solve the problem with a minimum of unnecessary coding.  It uses
many of Moose's features to good advantage, including:

=over 4

=item

All attributes have associated types that are checked in their
getters.  Some constraints are broad, e.g. C<Zephyr::App>'s id
attribute is simply constrained to be a string.  Others are more
complicated, the objects that can be added to the set of observers in
classes that consume the C<Zephyr::Role::Selectable> role must "duck
type" appropriately (they must be objects that support the proper two
notification methods).  Alternatively, these objects could be
constrained to "do" a role (as one might use an interface class in
Java).  These constraints only require a line or two of code.

=item

The 'is_selectable' attribute provided by the
C<Zephyr::Role::Selectable> role uses a trigger to walk a list of
observers and notify them when the selection state changes.

=item

All of the classes/roles take advantage of "native traits" to avoid
having to write [and therefor test!] boilerplate code that maintains
attributes which are lists and hashes.

=back

=head2 Log::Log4perl

The code uses Log::Log4perl to stub out a production logging
infrastructure.  It currently uses ":easy" mode to configure a
singleton logger that is used throughout the code base, it's easy to
get finer granularity by explicitly getting a "logger" at various
points in the code and/or adding logger attributes to classes.  The
t/demo.t test also uses ":easy" mode's C<easy_init> to set up a single
"screen appender" (all active output goes to STDERR) and to set a
logging level.  Finer granularity is easily available in a production
application.

=head1 THE PACKAGING

The code is packaged into a CPAN compatible distribution using
L<Dist::Zilla>.  Its configuration lives in the C<dist.ini> file, in a
real company setting I'd gather the appropriate set of plugins into a
PluginBundle that could be reused among all of the company's projects
and cut the file down to 5 or so lines.  I'd also add classes to
provide company specific copyright and licensing information.

L<Dist::Zilla> provides many advantages, including:

=over 4

=item

Authors only need to write the unique parts of their POD
documentation.  They must provide major sections, including an
abstract, a description, a synopsis, which are reorganized into the
standard CPAN ordering.  They must provide documentation for
attributes, methods, and functions which L<Dist::Zilla> gathers into
major sections and recognizes for them.  L<Dist::Zilla> takes care of
inserting license and copyright information and providing consistent
version numbers in all of the modules.

=item

L<Dist::Zilla> provides automated prerequisite handling.  This alone
is worth the cost of admission.

=item

L<Dist::Zilla> provides automated version number handling.  This alone
is worth the cost of admission.

=item

L<Dist::Zilla> provides a number of boilerplate tests

=item

While I haven't taken advantage of it here, L<Dist::Zilla> can
automate the tests of making a release, including tagging in a
repository and/or uploading the distribution to a shared server
(e.g. CPAN or internal).

=item

While I haven't taken advantage of it here, L<Dist::Zilla> integrates
nicely with continuous build/integration systems like Hudson.

=back

=head1 AUTHOR

George Hartzell

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by George Hartzell.  No
license is granted to other entities.

=cut

