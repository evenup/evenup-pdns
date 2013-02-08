# == Define: pdns::zone
#
# This define installs BIND zonefiles for the bind backend in PowerDNS
#
#
# === Parameters
#
# [*source*]
#   String. Source of the zonefile
#
# [*ensure*]
#   String.  Controls if the file exists or is absent.  Default is present.
#
#
# === Examples
#
#   pdns::zone {
#     'corp.example.com':
#       source => 'puppet:///data/bind/crop.example.com.zone'
#   }
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
define pdns::zone (
  $source,
  $ensure = 'present',
) {

  include pdns
  Class['pdns::install'] ->
  Pdns::Zone[$name] ~>
  Class['pdns::service']

  $file_ensure = $ensure ? {
    'present' => 'file',
    default   => 'absent'
  }

  file {
    "/etc/pdns/zones/${name}.zone":
      ensure  => $file_ensure,
      owner   => 'pdns',
      group   => 'pdns',
      mode    => '0444',
      source  => $source,
  }

  concat::fragment{"${name}_zone":
    ensure  => $ensure,
    target  => '/etc/named.conf',
    content => "zone \"${name}\" IN { type master; file \"/etc/pdns/zones/${name}.zone\"; };",
  }
}

