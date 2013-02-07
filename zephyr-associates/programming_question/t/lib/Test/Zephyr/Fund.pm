package Test::Zephyr::Fund;

use strict;
use warnings;

use base qw(Test::Class);
use Test::Most;
use Test::MockObject;
use SelectionObserver;
use InvalidSelectionObserver;

sub class { 'Zephyr::Fund' };

sub startup : Tests(startup) {
  my $test = shift;
  my $class = $test->class;
  eval "use $class";
  die $@ if $@;
}

# all of the other tests depend on ->new(), underscore forces test to
# run early
sub _constructor : Tests(3) {
  my $test = shift;
  my $class = $test->class;
  can_ok $class, 'new';

  ok my $fund = $class->new(id => 'a'),
    '... and the constructor should succeed';
  isa_ok $fund, $class, '... and the object it returns';
}

sub id : Tests(4) {
  my $test = shift;
  my $class = $test->class;
  can_ok $class, 'id';

  my $fund;
  dies_ok { $fund = $class->new() } 'new dies without id';
  lives_ok { $fund = $class->new(id => 'a') } 'new lives with id';
  
  is $fund->id, 'a', 'Expect id string of "a"';
}

sub is_selected : Tests(2) {
  my $test = shift;
  my $class = $test->class;

  my $fund = $class->new(id => 'a');
  is $fund->is_selected, 0, '...selected defaults to false';
  $fund->select();
  is $fund->is_selected, 1, '...is_selected returns true after selecting';
}  

sub select_stuff : Tests(12) {
  my $test = shift;
  my $class = $test->class;

  my $fund = $class->new(id => 'a');
  my $observer = SelectionObserver->new(id => 'foo');
  is $observer->selected_count, 0, '... start off with 0 selecteds';
  is $observer->deselected_count, 0, '... start off with 0 deselecteds';

  # use obj addr as "name"...
  lives_ok { $fund->add_observers($observer, $observer) }
    '... adding an observer works.';
  

  my $invalid_observer = InvalidSelectionObserver->new(foo => 'bar');
  dies_ok { $fund->add_observers($invalid_observer, $invalid_observer) }
    '... adding an invalid observer dies.';

  $fund->select();
  is $observer->selected_count, 1, '... should now be 1 selecteds';
  is $observer->deselected_count, 0, '... and 0 deselecteds';
  # consecutive selections have no effect.
  $fund->select();
  is $observer->selected_count, 1, '... should now be 1 selecteds';
  is $observer->deselected_count, 0, '... and 0 deselecteds';
  
  # deselecting should inc deselected counter
  $fund->deselect();
  is $observer->selected_count, 1, '... should now be 1 selecteds';
  is $observer->deselected_count, 1, '... and 1 deselecteds';

  # after deletion, selecting should have no effect
  $fund->delete_observer($observer);
  $fund->select();
  is $observer->selected_count, 1, '... should now be 1 selecteds';
  is $observer->deselected_count, 1, '... and 0 deselecteds';

}  


1;
