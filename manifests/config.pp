# == Class: pdns::install
#
# This class ensures config files are created for the PowerDNS service
# It is not intended to be directly called.
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class pdns::config {

  File {
    notify  => Class['pdns::service']
  }

  file { ['/etc/pdns', '/etc/pdns-recursor', '/etc/pdns/zones']:
    ensure  => directory,
    owner   => 'pdns',
    group   => 'pdns',
    mode    => '0555',
  }

  file { '/etc/pdns/pdns.conf':
    ensure  => file,
    owner   => 'pdns',
    group   => 'pdns',
    mode    => '0444',
    content => template('pdns/pdns.conf.erb'),
  }

  file { '/etc/pdns/puppetdb.yaml':
    ensure  => file,
    owner   => 'pdns',
    group   => 'pdns',
    mode    => '0444',
    content => template('pdns/puppetdb.yaml.erb'),
  }

  file { '/etc/pdns-recursor/recursor.conf':
    ensure  => file,
    owner   => 'pdns',
    group   => 'pdns',
    mode    => '0444',
    content => template('pdns/recursor.conf.erb'),
  }

  concat { '/etc/named.conf':
    owner => 'pdns',
    group => 'pdns',
    mode  => '0444',
  }
}
