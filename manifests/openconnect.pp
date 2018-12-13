# See README.md for details.
define networkmanager::openconnect (
  $user,
  $gateway,
  $authtype,
  $xmlconfig,
  $uuid          = regsubst(
    md5($name), '^(.{8})(.{4})(.{4})(.{4})(.{12})$', '\1-\2-\3-\4-\5'),
  $ensure        = 'present',
  $id            = $name,
  $autoconnect   = false,
  $ipv4_method   = 'auto',
  $ipv6_method   = 'auto',
  $never_default = true,
) {

  Class['networkmanager::install'] -> Networkmanager::Openconnect[$title]

  # TODO : params for RHEL package names
  ensure_resource(
    'package', 'network-manager-openconnect', { ensure => present, }
  )

  case $::networkmanager::gui {
    'gnome': {
      # TODO : params for RHEL package names
      ensure_resource(
        'package', 'network-manager-openconnect-gnome', { ensure => present, }
      )
    }
    default: {}
  }

  file { "/etc/NetworkManager/system-connections/${name}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('networkmanager/openconnect.erb'),
    notify  => Exec['reload nm configuration'],
  }
}
