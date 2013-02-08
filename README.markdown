What is it?
===========

A Puppet module that installs PowerDNS authority and recursor servers
and a pipe backend for PowerDNS to resolve nodes based on facts in PuppetDB.
The authority server uses both a bind backend for static names and a
pipe backend to resolve hostnames from PuppetDB.  Unknown requests from
sources are forwarded to the recursor service on localhost.

Please see the comments in the various .pp files for details.

Released under the Apache 2.0 licence

Usage:
------
Configuration variables are retrieved from Hiera for configuring
the hostname of the PuppetDB server and frequency of the cache refresh
as well as a regex (if desired) to filter what requests should be
passed to the PuppetDB pipe backend.

To install:
<pre>
  include pdns
</pre>

To install a BIND zonefile for corp.example.com:
<pre>
  pdns::zone {
    'corp.example.com':
      source => 'puppet:///data/bind/crop.example.com.zone'
  }
</pre>

Hiera Variables:
----------------
* pdns::puppetdb_server - Hostname of the puppetdb server.
* pdns::puppetdb_logfile - Location to write the logfile for the pipe backend
* pdns::puppetdb_loglevel - Log level of the pipe backend
* pdns::puppetdb_reload - Frequency to refresh the node names from PuppetDB
* pdns::pdns_regex - Regex for matching what queries should be passed
to the PuppetDB pipe backend.  An example which would query the PuppetDB
backend for all hostnames in the corp.example.com domain and reverse lookups
for any IP in the 10/8 space would be:
<pre>
  ^(.*\.corp.example.com;.*$)|(\d{1,3}\.\d{1,3}\.\d{1,3}.10.in-addr.arpa;.*$))$
</pre>


Dependencies:
-------------
* [puppet-concat](https://github.com/ripienaar/puppet-concat)
* [evenup-ruby](https://github.com/evenup/evenup-ruby)


Known Issues:
-------------
* Only tested on RHEL 6.3 and puppet 3.0.1 using the pdns packages from EPEL


Contact:
--------
Justin Lambert / jlambert@letsevenup.com / @jlambert121
