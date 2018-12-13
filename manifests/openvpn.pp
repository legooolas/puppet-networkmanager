# See README.md for details.
define networkmanager::openvpn (
  $user,
  $ta_dir,
  $connection_type,
  $password_flags,
  $remote,
  $comp_lzo,
  $ca,
  $ta,
  $uuid          = regsubst(
    md5($name), '^(.{8})(.{4})(.{4})(.{4})(.{12})$', '\1-\2-\3-\4-\5'),
  $ensure        = 'present',
  $id            = $name,
  $autoconnect   = false,
  $ipv4_method   = 'auto',
  $never_default = true,
  $routes        = undef,
  $dns = undef,
) {

  Class['networkmanager::install'] -> Networkmanager::Openvpn[$title]

  # TODO : params for RHEL package names
  ensure_resource(
    'package', 'network-manager-openvpn', { ensure => present, }
  )

  case $::networkmanager::gui {
    'gnome': {
      # TODO : params for RHEL package names
      ensure_resource(
        'package', 'network-manager-openvpn-gnome', { ensure => present, }
      )
    }
    default: {}
  }

  file { "/etc/NetworkManager/system-connections/${name}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('networkmanager/openvpn.erb'),
    notify  => Exec['reload nm configuration'],
  }
}
