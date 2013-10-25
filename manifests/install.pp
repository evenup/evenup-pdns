# == Class: pdns::install
#
# This class installs the files and packages needed for the PowerDNS services.
# It is not intended to be directly called.
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class pdns::install {

  include ruby::httparty

  Package {
    notify  => Class['pdns::service']
  }

  File {
    notify  => Class['pdns::service']
  }

  package { 'pdns':
    ensure  => latest
  }

  package { 'pdns-backend-pipe':
    ensure  => latest
  }

  package { 'pdns-recursor':
    ensure  => latest
  }

  file { '/usr/sbin/pdns_puppetdb.rb':
    ensure  => file,
    owner   => 'pdns',
    group   => 'pdns',
    mode    => '0554',
    source  => 'puppet:///modules/pdns/pdns_puppetdb.rb'
  }

  file { $pdns::puppetdb_logfile:
    ensure  => file,
    owner   => 'pdns',
    group   => 'pdns',
    mode    => '0664',
    replace => false,
    source  => 'puppet:///modules/pdns/empty',
  }
}
