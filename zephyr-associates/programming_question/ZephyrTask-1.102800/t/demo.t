
use Test::Most tests => 14;
use Test::Output;

use lib 't/lib';

use Log::Log4perl qw(:easy);
use SelectionObserver;
use Zephyr::App;
use Zephyr::Fund;

Log::Log4perl->easy_init($DEBUG); # to see messages at debug level and below

# create a top level app, check that new() logs as expected.
my $app;
stderr_like { $app = Zephyr::App->new() }
  qr/^.*Made a new Zephyr::App object with init_args:.*$/,
  'Zephyr::App logs init_args as expected';

# create a set of funds to play with, check that new() logs as expected.
my @funds;
stderr_like { @funds = map { Zephyr::Fund->new(id => $_) } qw(a b c d) }
  qr/^.*Made a new Zephyr::Fund object with init_args: id => a.*$/s,
  'Zephyr::Fund logs init_args as expected';

# add the funds to the app
$app->add_funds($_->id => $_) for (@funds);

# count 'em.
is $app->fund_count, 4, 'expect 4 funds';

# select fund 'a' and fund 'c'
$app->select_funds( qw( a c ));

# check that the right funds are selected
is $app->get_fund('a')->is_selected, 1, 'a is selected';
is $app->get_fund('b')->is_selected, 0, 'b is NOT selected';
is $app->get_fund('c')->is_selected, 1, 'c is selected';
is $app->get_fund('d')->is_selected, 0, 'd is NOT selected';

# delete fund c
$app->delete_fund('c');

# now there should be 3
is $app->fund_count, 3, 'expect 3 funds';

# and they should be the three we expect
my @ids = sort $app->fund_ids;
cmp_deeply(\@ids, ['a', 'b', 'd'], 'expected a, b, and d');

# and show off the observer functionality, depends on the
# simple selection observer defined for the unit tests.
# check that actions that actually change the state fire logging events.
my $observer = SelectionObserver->new(id => 'bar');
$app->get_fund('a')->add_observers('foo', $observer);

stderr_like { $app->get_fund('a')->deselect() }
  qr/.*Notifying bar of deselection$/s,
  'deselection should log a message';

stderr_like { $app->get_fund('a')->select() }
  qr/.*Notifying bar of selection$/s,
  'selection should log a message';

$app->get_fund('a')->select();  # this should not fire observer
stderr_is { $app->get_fund('a')->select() } '',
  'selection when already selected should NOT log a message';

is $observer->selected_count, 1, 'should see 1 selection';
is $observer->deselected_count, 1, 'should see 1 deselection';
