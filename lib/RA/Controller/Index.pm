package RA::Controller::Index;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::mysql;

sub index {
  my $self = shift;

  $self->render();
}


1;
