# == Class: pdns::install
#
# This class manages the Sensu monitoring configuration.
# It is not intended to be directly called.
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class pdns::monitoring::sensu {
  sensu::check { 'pdns-recursor-running':
    handlers    => ['default'],
    standalone  => true,
    command     => '/etc/sensu/plugins/check-procs.rb -p /usr/sbin/pdns_recursor -c 1 -C 1',
  }

  sensu::check { 'pdns-server-running':
    handlers    => 'default',
    standalone  => true,
    command     => '/etc/sensu/plugins/check-procs.rb -p /usr/sbin/pdns_server -w 2 -c 2 -W 2 -C 1',
  }

  sensu::check { 'dns-resolution':
    handlers    => 'default',
    standalone  => true,
    command     => '/etc/sensu/plugins/check-dns.rb -d google.com',
  }

  sensu::subscription { 'pdns': }
}
