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
  address.split("@").last
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
  message.reply_to = "#{address_from.gsub('@', '#')}-#{address_to}"
  message.deliver
else
  output_address, key = address_to.split("-")
  puts [output_address, key].join(",")
  if row = db.get_first_row("select * from addresses where address = ? and destination = ?",
                            [key, address_from])
    message.to = output_address.gsub('#', '@')
    message.from = "#{key}@#{domain_from_email(address_to)}"
    puts message.to_s
    message.deliver
  end
end

