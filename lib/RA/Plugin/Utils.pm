package RA::Plugin::Utils;
use Mojo::Base 'Mojolicious::Plugin';

use Carp;
use Mojo::mysql;


sub register {
  my ( $self, $app, $args ) = @_;
  $args ||= {};

  # database object
  $app->helper(mysql_ra => sub { 
    state $mysql_ra = Mojo::mysql->new(shift->config('ra_db_conn'));
  });

}

1;
__END__
