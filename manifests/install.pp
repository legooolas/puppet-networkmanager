class networkmanager::install (
  $nm_package       = $::networkmanager::params::nm_package,
  $nm_gnome_package = $::networkmanager::params::nm_gnome_package,
  $nm_kde_package   = $::networkmanager::params::nm_kde_package,
) inherits networkmanager::params {
  package { $nm_package:
    ensure => $::networkmanager::version,
  }
  case $::networkmanager::gui {
    'gnome': {
      package { $nm_gnome_package:
        ensure => $::networkmanager::version,
      }
    }
    'kde': {
      package { $nm_kde_package:
        ensure => present,
      }
    }
    default: {}
  }
}
