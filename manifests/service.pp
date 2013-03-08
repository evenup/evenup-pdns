# == Class: pdns::install
#
# This class manages the PowerDNS services
# It is not intended to be directly called.
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class pdns::service {

  service { 'pdns':
    ensure  => running,
    enable  => true,
    restart => '/etc/init.d/pdns restart',
  }

  service { 'pdns-recursor':
    ensure  => running,
    enable  => true,
  }

  $monitoring = hiera('monitoring', '')

  case $monitoring {
    'sensu': {
      sensu::check { 'pdns-recursor-running':
        handlers    => ['default'],
        standalone  => true,
        subscribers => ['pdns'],
        command     => '/etc/sensu/plugins/check-procs.rb -p /usr/sbin/pdns_recursor -c 1 -C 1',
        refresh     => 1800,
      }

      sensu::check { 'pdns-server-running':
        handlers    => 'default',
        standalone  => true,
        subscribers => ['pdns'],
        command     => '/etc/sensu/plugins/check-procs.rb -p /usr/sbin/pdns_server -w 2 -c 2 -W 2 -C 1',
        refresh     => 1800,
      }

      sensu::subscription { 'pdns': }
    }
  }
}