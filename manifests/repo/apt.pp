# requires
#   puppetlabs-apt
#   puppetlabs-stdlib
class rabbitmq::repo::apt(
  $location    = 'http://www.rabbitmq.com/debian/',
  $release     = 'testing',
  $repos       = 'main',
  $include     = { src => false },
  $key         = {
    id         => 'F78372A06FF50C80464FC1B4F7B8CEA6056E8E56',
    source     => 'http://www.rabbitmq.com/rabbitmq-signing-key-public.asc',
  },
  $key_content = undef,
  ) {

  $pin = $rabbitmq::package_apt_pin

  Class['rabbitmq::repo::apt'] -> Package<| title == 'rabbitmq-server' |>

  $ensure_source = $rabbitmq::repos_ensure ? {
    false   => 'absent',
    default => 'present',
  }

  apt::source { 'rabbitmq':
    ensure      => $ensure_source,
    location    => $location,
    release     => $release,
    repos       => $repos,
    include_src => $include[src],
    key         => $key[id],
    key_source  => $key[source],
    key_content => $key_content,
  }

  if $pin != '' {
    validate_re($pin, '\d\d\d')
    apt::pin { 'rabbitmq':
      packages => 'rabbitmq-server',
      priority => $pin,
    }
  }
}
