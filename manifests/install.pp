# TODO - document me
class pdns::install {

  include concat::setup

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

  concat { '/etc/named.conf':
    owner => 'pdns',
    group => 'pdns',
    mode  => '0444',
  }
}