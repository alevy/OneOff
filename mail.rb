#!/usr/bin/env ruby

require 'rubygems'
require 'pony'
require 'mail'
require 'sqlite3'
require 'sha1'

def name_from_email(address)
  address.split("@").first
end

def domain_from_email(address)
  address.split("@").last.split('.')[-2..-1].join('.')
end

message = Mail.new(STDIN.read)
address_to = message.to.first
address_to_name = name_from_email(address_to)
address_from = message.from.first

db = SQLite3::Database.new(File.join(File.dirname(__FILE__), "addresses.db"))
row = db.get_first_row("select destination, origin from addresses where address = ?", [address_to_name])
if row
  destination = row[0]
  origin = row[1]
  
  unless origin and Regexp.new(origin).match(address_from)
    return unless not origin and
        SHA1.hexdigest("#{domain_from_email(address_from)}|#{destination}") == address_to_name
  end
  
  message.to = destination
  message.reply_to = address_to
  message.deliver
elsif row = db.get_first_row("select destination, origin from addresses where address = ?", [address_from])
  
end



