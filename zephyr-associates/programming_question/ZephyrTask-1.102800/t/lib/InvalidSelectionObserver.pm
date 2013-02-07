# little class that responds to {,de}selecttion notification
# by incrementing counters
package InvalidSelectionObserver;
use Moose;

has foo => (is => 'rw', isa => 'Str');

no Moose;
1;
