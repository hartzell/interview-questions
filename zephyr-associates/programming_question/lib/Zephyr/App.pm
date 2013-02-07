
package Zephyr::App;

# ABSTRACT: An container for Zephyr apps.

=head1 DESCRIPTION

A simple top level container for a Zerphy App.  Currently keeps track
of a set of Zephyr::Fund objects.

=head1 SYNOPSIS

 use Zephyr::App;
 use Zephyr::Fund;

 # create an app
 my $app = Zephyr::App->new();
 
 # create a set of funds to play with
 my @funds = map { Zephyr::Fund->new(id => $_) } qw(a b c d);
 
 # add the funds to the app
 $app->add_funds($_->id => $_) for (@funds);
 
 my $four_count = $app->fund_count;
 
 # select fund 'a' and fund 'c'
 $app->select_funds( qw( a c ));
 
 $app->delete_fund('c');

 my $three_count = $app->fund_count;
 
 # should be qw(a b c)
 my @ids = sort $app->fund_ids;

=cut

use Moose;
use warnings;

use Log::Log4perl qw( :easy );

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

=attr _funds

A privatish hash to hold the set of funds.  Shouldn't need to be
accessed directly.

=method add_funds

Add a set of funds to the app.  Takes a set of id => $fund pairs.

See the SYNOPSIS for an example.

=method get_fund

Return a fund by its id.  Returns undef if there is no fund with the
given id.

See the SYNOPSIS for an example.

=method delete_fund

Delete a fund by its id.

See the SYNOPSIS for an example.

=method fund_count

Return the number of funds stored in the app.

See the SYNOPSIS for an example.

=method fund_ids

Returns a list of the ids of the funds stashed in the app.

See the SYNOPSIS for an example.

=cut

has _funds => (
               traits => ['Hash'],
               is => 'rw',
               isa => 'HashRef[Zephyr::Fund]',
               default => sub { {} },
               handles => {
                           add_funds => 'set',
                           get_fund => 'get',
                           delete_fund => 'delete',
                           fund_count => 'count',
                           fund_ids => 'keys',
                          },
              );

=method select_funds

Select a set of funds, given a list of ids.  Dies on encountering an
id which is not associated with the app.

=cut

sub select_funds {
  my $self = shift;
  my @ids = @_;
  
  for my $id (@ids) {
    my $fund = $self->get_fund($id);
    die "No fund with id: $id" unless $fund;

    $fund->select() unless $fund->is_selected();
  }
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
