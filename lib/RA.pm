package RA;
use Mojo::Base 'Mojolicious';

our $VERSION = '0.1';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by config file
  my $config = $self->plugin('Config', {
    default => {
      secrets => ['2498609287df54rt562at453kl67531'],
    },
    file => 'ra.conf',
  });
  delete $self->defaults->{config}; # safety - not to pass passwords to stashes

  # Configure the application
  #$self->mode('production');
  #$self->log->level('info');
  $self->secrets($config->{secrets});
  $self->sessions->cookie_name('ra');
  $self->sessions->default_expiration(0);

  # upload file limit 16mb
  $self->max_request_size(16777216);

  $self->defaults(version => $VERSION);

  # Router authentication routine
  $self->hook(before_dispatch => sub {
    my $c = shift;

    my $remote_user;
    my $ah = $c->config('auth_user_header');
    if ($ah) {
      $remote_user = lc($c->req->headers->header($ah));
    } else {
      $remote_user = lc($c->req->env('REMOTE_USER'));
    }
    #FIXME DEBUG FIXME
    $remote_user = 'ural';

    unless ($remote_user) {
      $c->render(text => 'Необходима аутентификация', status => 401);
      return undef;
    }
    $c->stash(remote_user => $remote_user);

    return 1;
  });

  # Router
  my $r = $self->routes;

  $r->get('/')->to('index#index');
}


1;
