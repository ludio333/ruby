#!/usr/bin/env ruby
# encoding: utf-8
require 'rubygems'
require 'net/https'
require 'uri'
require 'net/smtp'
require 'logger'

FROM_ADDRESS = 'noreply@chingyu.net'
SMTP_HOST = '1.1.1.1'
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
$logger = Logger.new("/root/access/send.log",10,1024000)
$logger.level = Logger::INFO


def scan_ip(ip)
	uri = URI("http://www.ip138.com/ips138.asp?ip=#{ip}&action=2")
	out=Net::HTTP.get(uri)
	out = out.force_encoding('GB2312')
	out = out.encode('UTF-8')
	out = out.to_s
	reg = />参考数据一：([^<]+)/m
	message = ''
	out.scan(reg).each{|x| message = message + x.to_s + "\n" }
	message
end

log = {}
Dir.chdir('/var/log/squid/')
localtime = Time.new
localtime = localtime.to_f - 86400
File.open("access.log","r") do |file|
file.each{|x|
	line = x.split
	if(line[3]=~/\/200/ and line[0].to_f > localtime)
	log[line[2]] = log[line[2]].to_a << Time.at(line[0].to_f)
	end 
}
end
message = ''
log.each{|x,y|mes = scan_ip(x)
	message = message + x.chomp + mes.chomp + "最后访问时间：" + y[-1].to_s.chomp + "\n"
	#puts y
}

reply('abc@def.com','chingyu过去24小时访问记录',message) 
