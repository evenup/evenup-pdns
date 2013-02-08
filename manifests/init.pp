# == Class: pdns
#
# This class installs and configures the authorative and recursive PowerDNS
# services.  It also includes a script and pipe backend which will resolve
# queries based on information in PuppetDB.
#
#
# === Examples
#
# * Installation:
#     class { 'apache': }
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class pdns {

  $puppetdb_server = hiera('pdns::puppetdb_server', 'puppet')
  $puppetdb_logfile = hiera('pdns::puppetdb_logfile', '/var/log/pdns_puppetdb.log')
  $puppetdb_loglevel = hiera('pdns::puppetdb_loglevel', 'info')
  $puppetdb_reload = hiera('pdns::puppetdb_reload', '30')
  $pdns_regex = hiera('pdns::pdns_regex', '')

  class {'pdns::install': } ->
  class {'pdns::config': } ->
  class {'pdns::service': } ->
  Class['pdns']

}
