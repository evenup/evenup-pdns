# TODO - document me
class pdns {

  $puppetdb_server = hiera('pdns::puppetdb_server', 'puppet')
  $puppetdb_logfile = hiera('pdns::puppetdb_logfile', '/var/log/pdns_puppetdb.log')
  $puppetdb_loglevel = hiera('pdns::puppetdb_loglevel', 'info')
  $puppetdb_reload = hiera('pdns::puppetdb_reload', '30')

  class {'pdns::install': } ->
  class {'pdns::config': } ->
  class {'pdns::service': } ->
  Class['pdns']

}
