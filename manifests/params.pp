# Simple params for setting package names, paths, etc

class networkmanager::params {
  case $::facts['os']['family'] {
    'RedHat': {
      $nm_service       = 'NetworkManager'
      $nm_package       = 'NetworkManager'
      $nm_gnome_package = 'network-manager-applet'
      $nm_kde_package   = 'kde-plasma-networkmanagement'
    }
    'Debian': {
      $nm_service       = 'network-manager'
      $nm_package       = 'network-manager'
      $nm_gnome_package = 'network-manager-gnome'
      $nm_kde_package   = 'plasma-nm'
    }
    default: {
      fail("Unsupported OS family ${facts['os']['family']}, sorry!")
    }
  }
}
