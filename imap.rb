#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'net/imap'
require 'base64' 
require 'mail'
#require 'tmail'
#imap = Net::IMAP.new('imap.gmail.com', 993, true)
#imap.login('', '')
#imap.select('INBOX')
#mailIds = imap.search(['UNSEEN'])
#mailIds.each do |id|
#  msg = imap.fetch(id, 'RFC822')[0].attr['RFC822']
#  puts msg
#  imap.store(id, "+FLAGS", [:Seen])
#end 
#imap.logout()
#imap.disconnect()

imap = Net::IMAP.new('imap.gmail.com', 993, true)
#imap.authenticate('LOGIN', '', '')
imap.login('', '')
imap.select('INBOX')
imap.search(["UNSEEN"]).each do |message_id|
#envelope = imap.fetch(message_id, "BODYSTRUCTURE")[0].attr["BODYSTRUCTURE"]
#body  = imap.fetch(message_id, "RFC822")[0].attr["RFC822"]
imap.fetch(message_id, ["BODY[HEADER]", "BODY[TEXT]", "ENVELOPE"]).each {|mail|
  title = mail.attr["ENVELOPE"].subject
  #p Mail::Encodings.value_decode(title)
  body  = mail.attr["BODY[TEXT]"]
  data = Mail.read_from_string(body) 
 # p data.body
 # p data.text_part
  
  code =  data.has_charset? ? data.charset : nil
if code
p code
p data.body
else
p data.body
end
#  p data.has_content_transfer_encoding? 
#p  data.content_transfer_encoding
#  p data.has_content_type? #p "content_type" + data.content_type
#  p  data.content_type
#  p data.has_mime_version? #p "mime_version" + data.mime_version
#  p  data.mime_version
  #p data.multipart? #p "multipart" + data.multipart?
}
#data = message.multipart? ? (message.text_part ? message.text_part.body.decoded : nil) : message.body.decoded
#p data
#envelope = imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
#body = imap.fetch(message_id, "RFC822")[0].attr["RFC822"]
#  puts "#{envelope.from[0].name}: \t#{envelope.subject}"
#sub = envelope.subject
#body = imap.fetch(message_id,'BODY[TEXT]')[0].attr['BODY[TEXT]']
#p body.partition.methods
#mail = Mail.read_from_string(body)
#p mail.methods
#p mail.body.decoded
##data = mail.body.decoded
#code = mail.charset
#data = mail.body.decoded
#p data.methods
#p data.encode('utf-8',code) 


#puts Mail::Encodings.value_decode(data)
#puts Mail::Encodings.value_decode(envelope)
#name =~ /.*?\?([^\?]+)\?(.*?)$/;
#puts Mail::Encodings.value_decode(sub)
#puts Mail::Encodings.value_decode("#{envelope.from[0].name}")
#code = $1
#name = Base64.decode64(name)
#p name
#p name.encode!('utf-8',code)


#cname = Base64.decode64(tname)
#name =~ /.*?\?([^\?]+)\?(.*?)$/;
#p envelope.from[0]
#p envelope
#imap.store(message_id, "+FLAGS", [:Seen])
end
