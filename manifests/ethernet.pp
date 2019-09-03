# See README.md for details.
define networkmanager::ethernet (
  $autoconnect_priority,
  $duplex,
  $interface,
  $ensure      = present,
  $ipv4_method = 'auto',
  $ipv6_method = 'auto',
) {

  Class['networkmanager::install'] -> Networkmanager::Ethernet[$title]

  file { "/etc/NetworkManager/system-connections/${name}":
    ensure => $ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

### Working file content to create and make configurable:
# [connection]
# id=Campus-wired
# uuid=33671da2-e31b-460e-af70-2e2bbe10a5aa
# type=ethernet
# interface-name=eno2
# permissions=
# type=802-3-ethernet
# autoconnect-priority=5
# 
# [ethernet]
# mac-address-blacklist=
# 
# [ipv4]
# dns-search=
# method=auto
# 
# [ipv6]
# addr-gen-mode=stable-privacy
# dns-search=
# method=auto

  if $ensure == 'present' {
    Ini_setting {
      ensure  => present,
      path    => "/etc/NetworkManager/system-connections/${name}",
      notify  => Exec['reload nm configuration'],
    }

    # section: 803-3-ethernet
    ini_setting { "${name}/802-3-ethernet/duplex":
      section => '802-3-ethernet',
      setting => 'duplex',
      value   => $duplex,
    }

    # section: connection
    ini_setting { "${name}/connection/id":
      section => 'connection',
      setting => 'id',
      value   => $name,
    }

    ini_setting { "${name}/connection/type":
      section => 'connection',
      setting => 'type',
      value   => '802-3-ethernet',
    }

    ini_setting { "${name}/connection/autoconnect-priority":
      section => 'connection',
      setting => 'autoconnect-priority',
      value   => $autoconnect_priority,
    }

    # section: ipv4
    ini_setting { "${name}/ipv4/method":
      section => 'ipv4',
      setting => 'method',
      value   => $ipv4_method,
    }

    # section: ipv6
    ini_setting { "${name}/ipv6/method":
      section => 'ipv6',
      setting => 'method',
      value   => $ipv6_method,
    }

    ini_setting { "${name}/connection/interface-name":
      section => 'connection',
      setting => 'interface-name',
      value   => "${interface};",
    }
  }
}
