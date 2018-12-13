class networkmanager::service {
  include ::networkmanager::params

  $ensure = $::networkmanager::start ? {
    true    => running,
    default => stopped,
  }

  service { $::networkmanager::params::nm_service:
    ensure => $ensure,
    enable => $::networkmanager::enable,
  }

  exec {'reload nm configuration':
    name        => '/usr/bin/nmcli connection reload',
    refreshonly => true,
  }
}
