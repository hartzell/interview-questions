# little class that responds to {,de}selecttion notification
# by incrementing counters
package SelectionObserver;
use Moose;
has 'id' => (
             is => 'rw',
             isa => 'Str',
             default => sub {'default'},
            );
has 'selected_count' => (
                         traits => ['Counter'],
                         is => 'ro',
                         isa => 'Num',
                         default => 0,
                         handles => {
                                     inc_selected_count  => 'inc',
                                     reset_selected_count => 'reset',
                                    },
                        );
has 'deselected_count' => (
                           traits => ['Counter'],
                           is => 'ro',
                           isa => 'Num',
                           default => 0,
                           handles => {
                                       inc_deselected_count  => 'inc',
                                       reset_deselected_count => 'reset',
                                      },
                          );
sub notify_fund_is_selected { $_[0]->inc_selected_count}
sub notify_fund_is_deselected { $_[0]->inc_deselected_count}
no Moose;
1;
