#!/usr/bin/ruby

# Queries the PuppetDB V2 interface for nodes
# Some ideas taken from https://github.com/ripienaar/ruby-pdns
# PowerDNS pipe backend documentation: http://doc.powerdns.com/backends-detail.html#pipebackend
#
# Copyright EvenUp Inc 2013
#
# Authors:
# Justin Lambert <jlambert@letsevenup.com>
#
#
require "rubygems"
require "httparty"
require "open-uri"
require 'json'
require 'logger'
require 'yaml'

class PDNSQuery
    def initialize

      config = YAML.load_file('/etc/pdns/puppetdb.yaml')
      @log = Logger.new(config[:logfile])
      case config[:loglevel]
      when 'debug'
        @log.level = Logger::DEBUG
      when 'info'
        @log.level = Logger::INFO
      when 'warn'
        @log.level = Logger::WARN
      when 'error'
        @log.level = Logger::ERROR
      when 'fatal'
        @log.level = Logger::FATAL
      else
        @log.fatal "Unknown logging level"
        exit
      end

      @log.info "Starting Up"
      STDOUT.sync = true
      STDIN.sync = true
      @reload_interval = config[:reload_interval]
      @results = {}
      @hostname = config[:server]

      unless STDIN.gets.chomp =~ /HELO\t/
        @log.fatal "Did not receive an ABI version 1 handshake correctly from pdns"
        exit
      end

      load_data
      puts "OK\tReady for queries"
      go
    end

  def go
    while true
      # Whichever comes first, STDIN or reload_interval
      r = select([STDIN], nil, nil, @reload_interval)
      if r == nil
        load_data
      else
        orig_request = STDIN.gets.chomp
        @log.debug "Request received: '#{orig_request}'"
        request = orig_request.split("\t")
        if request.length < 2
          puts 'FAIL'
        else
          hostname = request[1].downcase
          case request[0]
          when 'Q'
            @log.debug "Looking up #{hostname}"
            if @results.has_key?(hostname) && (request[3] == 'ANY' || request[3] == 'A')
              @log.debug "#{hostname} found"
              puts "DATA\t#{hostname}\tIN\tA\t3600\t#{request[4]}\t#{@results[request[1]]}"
            else
              @log.debug "#{hostname} not found"
            end
            puts 'END'
          when 'AXFR'
            @results.each do |host,ip|
              puts "DATA  #{host} IN  A 3600  1 #{ip}"
            end
            puts 'END'
          when 'PING'
            puts 'PONG'
            puts 'END'
          else
            puts 'FAIL'
          end
        end
      end
    end
  end

  def load_data
    @log.debug "Starting data load"

    query = URI::encode('query=["=", "name", "ipaddress"]')
    options = { :headers => { "Accept" => "application/json" }, :query => query }
    begin
      response = HTTParty.get("http://#{@hostname}:8080/v2/facts", options)
    rescue SocketError
      @log.warn "Couldn't connect to PuppetDB - SocketError.  Will retry at next load"
    rescue => exception
      @log.fatal "#{exception.backtrace}: #{exception.message} (#{exception.class})"
    else
      @log.debug "Processing response"
      new_results = {}
      if response.success?
        JSON.parse(response.body).each do |result|
          # Forward lookup
          new_results[result['certname'].downcase] = result['value']
          # Reverse lookup
          new_results[result['value']] = result['certname'].downcase
        end
        if new_results.length == 0
          @log.warn "Query returned 0 results.  Refusing to flush old results"
        else
          @log.info "#{new_results.length} records loaded (#{@results.length} previously)" if new_results.length != @results.length
          @results = new_results
        end
      else
        @log.warn "response was unsuccessful #{response.code}"
      end
    end
  end

  def query hostname
    @results[hostname]
  end
end

PDNSQuery.new

