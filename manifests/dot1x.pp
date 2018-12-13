# See README.md for details.
define networkmanager::dot1x (
  $ca_cert,
  $eap,
  $identity,
  $password,
  $phase2_auth,
  $autoconnect_priority,
  $duplex,
  $ensure      = present,
  $ipv4_method = 'auto',
  $ipv6_method = 'auto',
#  $directory              = '/usr/share/glib-2.0/schemas',
#  $ignore_ca_cert         = false,
#  $ignore_phase2_ca_cert  = false,
) {

  Class['networkmanager::install'] -> Networkmanager::Dot1x[$title]

  file { "/etc/NetworkManager/system-connections/${name}":
    ensure => $ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

### Working file content to create and make configurable:
# [802-3-ethernet]
# duplex=full
#
# [connection]
# id=$NM_CONNECTION
# type=802-3-ethernet
# autoconnect-priority=5
#
# [ipv4]
# method=auto
#
# [ipv6]
# method=auto
#
# [802-1x]
# eap=peap
# identity=host/$IT_TAG
# ca-cert=$CERT_DIR/$CERT_NAME
# phase2-auth=mschapv2
# password=$MACHINE_PASSWORD


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

    # section: 802-1x
    ini_setting { "${name}/802-1x/eap":
      section => '802-1x',
      setting => 'eap',
      value   => "${eap};",
    }

    ini_setting { "${name}/802-1x/identity":
      section => '802-1x',
      setting => 'identity',
      value   => $identity,
    }

    ini_setting { "${name}/802-1x/ca-cert":
      section => '802-1x',
      setting => 'ca-cert',
      value   => $ca_cert,
    }

    ini_setting { "${name}/802-1x/phase2-auth":
      section => '802-1x',
      setting => 'phase2-auth',
      value   => $phase2_auth,
    }

    ini_setting { "${name}/802-1x/password":
      section => '802-1x',
      setting => 'password',
      value   => $password,
    }
  }

#  if ( $eap =~ /^tls|^ttls|^peap/ ) {
#    file { "${directory}/org.gnome.nm-applet.eap.${uuid}.gschema.xml":
#      ensure  => file,
#      content => template('networkmanager/org.gnome.nm-applet.eap.gschema.xml.erb'),
#    }
#    ~> exec { "Compile modifications for ${uuid}":
#      command     => "/usr/bin/glib-compile-schemas ${directory}",
#      refreshonly => true,
#    }
#
#    exec {"sudo -u ${user} DISPLAY=:0 gsettings set org.gnome.nm-applet.eap.${uuid} ignore-ca-cert ${ignore_ca_cert}":
#      unless  => "[ $(sudo -u ${user} DISPLAY=:0 gsettings get org.gnome.nm-applet.eap.${uuid} ignore-ca-cert) = ${ignore_ca_cert} ]",
#      path    => '/usr/bin/',
#      require => File["${directory}/org.gnome.nm-applet.eap.${uuid}.gschema.xml"],
#    }
#
#    exec {"sudo -u ${user} DISPLAY=:0 gsettings set org.gnome.nm-applet.eap.${uuid} ignore-phase2-ca-cert ${ignore_phase2_ca_cert}":
#      unless  => "[ $(sudo -u ${user} DISPLAY=:0 gsettings get org.gnome.nm-applet.eap.${uuid} ignore-phase2-ca-cert) = ${ignore_phase2_ca_cert} ]",
#      path    => '/usr/bin/',
#      require => File["${directory}/org.gnome.nm-applet.eap.${uuid}.gschema.xml"],
#    }
#  }
}
