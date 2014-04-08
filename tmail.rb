#!/usr/bin/env ruby
require 'rubygems'
require 'net/imap'
require 'hpricot'
require 'open-uri'
require 'fileutils'
require 'tmail'
# 首先登录imap服务器，如果是gmail的话，需要加上ssl的支持
number_of_retries = 0
username = 'ludio333'
password = 'Ludio333!!!'
begin
	@server = Net::IMAP.new('imap.gmail.com', 993, true)
	rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT, SocketError => e
	number_of_retries += 1
	sleep(rand(20))
	retry    if number_of_retries < retry_count
	puts "cann't connect to imap server #{imap_server_addr} "
	raise e
end
	@server.login('username', 'password')
#选择inbox
	mailbox = 'inbox'
	@server.select(mailbox)
	count = @server.status(mailbox, ["UNSEEN"])["UNSEEN"]
	puts "#{count} message(s) unread"
	msgs = @server.search(["UNSEEN"])
	msgs.each do |msg_id|
	body = @server.fetch(msg_id, "RFC822")[0].attr["RFC822"]
	mail = TMail::Mail.parse(body)
	puts mail.from
	puts mail.to
# 打印邮件正文
	puts mail.body('unicode')
	if mail.has_attachments?
# fetch the attachments
	mail.parts.each_with_index do |part, index|
# This is how TMail::Attachment gets a filename
	file_name = (part['content-location'] &&['content-location'].body)||part.sub_header("content-type", "name")||part.sub_header("content-disposition", "filename")
	next unless file_name
#save the attachments
	file = File.new(file_name,'wb+')
	file.write(part.body)
	file.close
end
end
end
