
package Zephyr::Fund;
BEGIN {
  $Zephyr::Fund::VERSION = '1.102800';
}

# ABSTRACT: An object that models a fund.


use Moose;
use warnings;

use Log::Log4perl qw( :easy );

with 'Zephyr::Role::Selectable';


sub BUILD {
  my $self = shift;
  my $args = shift;
  
  DEBUG( 'Made a new ' . __PACKAGE__ . ' object with init_args: ' .
         join (", ",
               map {$_ . " => " . $args->{$_}} keys %$args
              )
       );
}



has id => (
           is => 'rw',
           isa => 'Str',
           required => 1,
          );


no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__
=pod

=head1 NAME

Zephyr::Fund - An object that models a fund.

=head1 VERSION

version 1.102800

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

=head1 DESCRIPTION

Simple object that models a fund.  It does the Selectable role to
enable selection and observers.

=head1 ATTRIBUTES

=head2 id

String valued identifier for this fund.

=head1 METHODS

=head2 BUILD

Hook into the build process and DEBUG a message of the arguments with
which we were called.

=head1 SEE ALSO

L<Zephyr::Role::Selectable>

=head1 AUTHOR

George Hartzell

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by George Hartzell.  No
license is granted to other entities.

=cut

