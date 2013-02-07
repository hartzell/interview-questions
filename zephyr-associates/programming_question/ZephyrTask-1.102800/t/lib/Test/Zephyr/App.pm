package Test::Zephyr::App;

use strict;
use warnings;

use base qw(Test::Class);
use Test::Most;
use Test::MockObject;

sub class { 'Zephyr::App' };

# create a couple of mock objects, with just enough brains.
# isa, id, select, is_selected
my $faux_fund_a = Test::MockObject->new();
$faux_fund_a->set_isa('Zephyr::Fund');
$faux_fund_a->set_always('id', 'a');
my $a_is_selected = 0;
$faux_fund_a->mock('select' , sub {$a_is_selected = 1});
$faux_fund_a->mock('is_selected' , sub {$a_is_selected});
my $faux_fund_b = Test::MockObject->new();
$faux_fund_b->set_isa('Zephyr::Fund');
$faux_fund_b->set_always('id', 'b');
my $b_is_selected = 0;
$faux_fund_b->mock('select' , sub {$b_is_selected = 1});
$faux_fund_b->mock('is_selected' , sub {$b_is_selected});

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

  ok my $app = $class->new(),
    '... and the constructor should succeed';
  isa_ok $app, $class, '... and the object it returns';
}

sub funds : Tests(6) {
  my $test = shift;
  my $class = $test->class;
  can_ok $class, 'add_funds';

  my $app = $class->new();
  
  lives_ok {$app->add_funds($faux_fund_a->id => $faux_fund_a,
                            $faux_fund_b->id => $faux_fund_b
                           );
          } '... can add two faux funds';
  is $app->fund_count, 2, 'Expect two funds';
  my $a = $app->get_fund('a');
  is $a->id, 'a', '... should get back fund "a"';

  $app->delete_fund('a');
  is $app->fund_count, 1, 'Expect 1 fund after deletion';

  is $app->get_fund('a'), undef, '... no fund "a" after deletion';
}

sub select_funds : Tests(4) {
  my $test = shift;
  my $class = $test->class;
  can_ok $class, 'select_funds';

  my $app = $class->new();
  
  $app->add_funds($faux_fund_a->id => $faux_fund_a,
                  $faux_fund_b->id => $faux_fund_b
                 );

  my $a = $app->select_funds('a');
  is $a_is_selected, 1, '... a is selected';
  is $b_is_selected, 0, '... b is NOT selected';

  dies_ok { $app->select_funds('z') } '... dies on unexpected fund id';

}

1;
