class networkmanager::install {
  include ::networkmanager::params

  package { $::networkmanager::params::nm_package:
    ensure => $::networkmanager::version,
  }
  case $::networkmanager::gui {
    'gnome': {
      package { $::networkmanager::params::nm_gnome_package:
        ensure => $::networkmanager::version,
      }
    }
    'kde': {
      package { $::networkmanager::params::nm_kde_package:
        ensure => present,
      }
    }
    default: {}
  }
}
