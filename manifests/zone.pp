# TODO - document me
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
    content => "zone \"${name}\" IN { type master; file \"/etc/pdns/${name}.zone\"; };",
  }
}

