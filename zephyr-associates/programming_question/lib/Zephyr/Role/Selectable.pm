
package Zephyr::Role::Selectable;

# ABSTRACT: A role for things that are selectable

=head1 DESCRIPTION

A role that adds makes objects "selectable".  It adds two attributes,
a public is_selected and private _selection_observers which is
accessed through helper methods (see below).

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

=cut

use Moose::Role;
use Moose::Util::TypeConstraints;
use Log::Log4perl qw(:easy);

=attr is_selected

Boolean attribute that keeps track of selection status.

=method select

Set the is_selected attribute to true.

=method deselect

Set the is_selected attribute to false.

=cut

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

=attr _selection_observers

Private-ish attribute, hashref of objects that duck-type as selectable
(support notify_fund_is_selected and notify_fund_is_deselected
methods).

Accessed via helper methods

=method add_observers

Adds one or more objects to the set of observers, each observer is an
identifier, object reference pair.

=method delete_observer

Delete an observer, specified by id.

=method observers

Returns a the list of observer objects.

=cut

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
