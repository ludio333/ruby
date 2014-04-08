#!/usr/bin/env ruby
# encoding : utf-8
require 'rubygems'
require 'net/https'
require 'uri'
require 'net/smtp'
require 'logger'

FROM_ADDRESS = 'noreply@mm.no.dudu-inc.com'
SMTP_HOST = '10.4.1.20'
def reply(to, subject, msg)
	mail = "To: #{to}\r\n" +
	"From: #{FROM_ADDRESS}\r\n" +
	"Subject: #{subject}\r\n" +
	"\r\n" +
	msg.to_s
	Net::SMTP.start(SMTP_HOST) do |smtp|
		begin
		smtp.send_mail(mail, FROM_ADDRESS,[ to ])
		$logger.info "send mail succ"
		rescue
		$logger.error "send mail failed"
		end
	end
end
$logger = Logger.new("/root/kerberos/rhel.log",10,1024000)
$logger.level = Logger::INFO

url = 'https://rhn.redhat.com/errata/rhel-server-6-errata.html'
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
reg = />([^<]*krb5[^<]*)<\/a><\/td>.*?class="last_column">([^<]+)</m
message = ''
out.scan(reg).each{|x| message = message + x.to_s + "\n" }
reply('xuan.liu@renren-inc.com','rhel && check syslog monthly',message)
