#!/usr/bin/env ruby
# encoding : utf-8

require 'rubygems'
require 'net/https'
require 'uri'
require 'net/smtp'
require 'logger'


#$logger = Logger.new("/root/kerberos/rhel.log",10,1024000)
#$logger.level = Logger::INFO

url = 'http://forex.hexun.com/rmbhl/'
uri = URI.parse(url)
	out = ''

http = Net::HTTP.new(uri.host, uri.port)

	http.use_ssl = true if uri.scheme == "https"
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	http.start {
		http.request_get(uri.path) {|res|
		out = res.body
		}
	}
out = out.force_encoding('GB2312')
out = out.encode('UTF-8')
reg = /美元\/人民币.*?>([\d\.]+)<\/td>/m
er = 6
out.scan(reg).each{|x| er = x[0].to_f }
