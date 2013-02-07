
package Zephyr::Role::Selectable;
BEGIN {
  $Zephyr::Role::Selectable::VERSION = '1.102800';
}

# ABSTRACT: A role for things that are selectable


use Moose::Role;
use Moose::Util::TypeConstraints;
use Log::Log4perl qw(:easy);


has is_selected => (
                    traits => ['Bool'],
                    is => 'rw',
                    isa => 'Bool',
                    default => 0,
                    handles => {
                                select => 'set',
                                deselect => 'unset',
                               },
                    trigger => sub {
                      my $self = shift;
                      my $new_value = shift;
                      my $prev_value = shift;
                      # only fire if value changed
                      if ($new_value != $prev_value) {
                        for my $observer ($self->observers) {
                          if ($new_value) {
                            INFO("Notifying " . $observer->id .
                                 " of selection");
                            $observer->notify_fund_is_selected();
                          }
                          else {
                            INFO("Notifying " . $observer->id .
                                 " of deselection");
                            $observer->notify_fund_is_deselected();
                          }
                        }
                      }
                    }
                   );

# define a Type the supports these useful message, used to constrain
# observers below
duck_type 'Zephyr::Fund::Notifiable::Selected' =>
  qw( id notify_fund_is_selected  notify_fund_is_deselected  );


has _selection_observers => (
                             traits => ['Hash'],
                             is => 'rw',
                             isa =>
                             'HashRef[Zephyr::Fund::Notifiable::Selected]',
                             default => sub { {} },
                             handles => {
                                         add_observers => 'set',
                                         delete_observer => 'delete',
                                         observers => 'values',
                                        },
                            );

no Moose::Role;
1;

__END__
=pod

=head1 NAME

Zephyr::Role::Selectable - A role for things that are selectable

=head1 VERSION

version 1.102800

=head1 SYNOPSIS

package MySelectableClass;
use Moose;
with 'Zephyr::Role::Selectable';
# etc ....

# elsewhere....
my $obj = MySelectableClass->new();
$obj->add_observers('id', $observer);
$obj->select();
$obj->deselect();
do_something() if ($obj->is_selected());
$obj->delete_observer('id');

=head1 DESCRIPTION

A role that adds makes objects "selectable".  It adds two attributes,
a public is_selected and private _selection_observers which is
accessed through helper methods (see below).

=head1 ATTRIBUTES

=head2 is_selected

Boolean attribute that keeps track of selection status.

=head2 _selection_observers

Private-ish attribute, hashref of objects that duck-type as selectable
(support notify_fund_is_selected and notify_fund_is_deselected
methods).

Accessed via helper methods

=head1 METHODS

=head2 select

Set the is_selected attribute to true.

=head2 deselect

Set the is_selected attribute to false.

=head2 add_observers

Adds one or more objects to the set of observers, each observer is an
identifier, object reference pair.

=head2 delete_observer

Delete an observer, specified by id.

=head2 observers

Returns a the list of observer objects.

=head1 AUTHOR

George Hartzell

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by George Hartzell.  No
license is granted to other entities.

=cut

