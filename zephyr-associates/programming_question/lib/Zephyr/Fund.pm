
package Zephyr::Fund;

# ABSTRACT: An object that models a fund.

=head1 DESCRIPTION

Simple object that models a fund.  It does the Selectable role to
enable selection and observers.

=head1 SYNOPSIS

 use Zephyr::Fund;

 # create a set of funds to play with
 my $fund = Zephyr::Fund->new(id => 'a');
 
 $fund->select();

 print "fund " . $fund->id . 
   $fund->is_selected ? " is" : "is not" .
     " selected.";

 # get an observer somehow....
 $fund->add_observers('id' => $observer);

 $fund->select();               # notifies observer
 $fund->deselect();             # notifies observer

 $fund->delete_observer('id');

=cut

use Moose;
use warnings;

use Log::Log4perl qw( :easy );

with 'Zephyr::Role::Selectable';

=method  BUILD

Hook into the build process and DEBUG a message of the arguments with
which we were called.

=cut

sub BUILD {
  my $self = shift;
  my $args = shift;
  
  DEBUG( 'Made a new ' . __PACKAGE__ . ' object with init_args: ' .
         join (", ",
               map {$_ . " => " . $args->{$_}} keys %$args
              )
       );
}


=attr id

String valued identifier for this fund.

=cut

has id => (
           is => 'rw',
           isa => 'Str',
           required => 1,
          );

=head1 SEE ALSO

L<Zephyr::Role::Selectable>

=cut

no Moose;
__PACKAGE__->meta->make_immutable;
1;
