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
#     class { 'pdns': }
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class pdns(
  $puppetdb_server    = 'puppet',
  $puppetdb_logfile   = '/var/log/pdns_puppetdb.log',
  $puppetdb_loglevel  = 'info',
  $puppetdb_reload    = '30',
  $pdns_regex         = '',
  $monitoring         = '',
) {

  class {'pdns::install': } ->
  class {'pdns::config': } ->
  class {'pdns::service': monitoring => $monitoring } ->
  Class['pdns']

}
