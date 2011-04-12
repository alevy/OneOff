#!/usr/bin/env ruby

require 'rubygems'
require 'sqlite3'
require 'sha1'

def name_from_email(address)
  address.split("@").first
end

def domain_from_email(address)
  address.split("@").last
end

db = SQLite3::Database.new(File.join(File.dirname(__FILE__), "addresses.db"))

destination, domain = $*
address = SHA1.hexdigest("#{domain_from_email(domain)}|#{destination}")

if db.execute("insert into addresses (address, destination) values(?, ?)", [address, destination])
  puts "Added #{[destination, domain, address].join(', ')}"
  exit 0
else
  puts "Failed"
  exit 1
end