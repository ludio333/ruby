#!/usr/bin/env ruby
# encoding: utf-8
require 'rubygems'
require 'spreadsheet'
require "mysql"
require 'net/https'
require 'uri'
require 'logger'

$logger = Logger.new("/root/inotify/insert.log",10,1024000)
$logger.level = Logger::INFO

Dir.chdir('/root/inotify')

def get_er
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
return er
end

def with_db
user = 'root'
pw = 'chingyu512'
db = 'dmd'
   dbh=Mysql.real_connect('localhost',user,pw,db)
   begin
     yield dbh
   rescue MysqlError => e
     print "Error code: ", e.errno, "/n"
     print "Error message: ", e.error, "/n"
   ensure
     dbh.close
   end
end

$table = 'dmd_dmd'
with_db do |db|
	db.query("TRUNCATE TABLE #{$table}")
end

#er = get_er
Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open 'excel.xls'
sheet1 = book.worksheet 'Sheet1'
sheet1.each do |row|
	row.delete_at(0)
	next unless row[0] =~ /^[0-9A-Z]/	
	row.collect{|x|if x.is_a?String
			x.strip!
			elsif x.is_a?Float
			x.to_i
			else
			x
		end
	}

	c_number,carat,color,clarity,cut,polish,symmetry,fluorescence,prices,s_prices = row
	clarity = case clarity
	when "SI2" then 1
	when "SI1" then 2
	when "VS2" then 3
	when "VS1" then 4
	when "VVS2" then 5
	when "VVS1" then 6
	when "IF" then 7
	when "FL" then 8
	end
	color = case color
	when "K".."Z" then 1
	when "J" then 2
	when "I" then 3
	when "H" then 4
	when "G" then 5
	when "F" then 6
	when "E" then 7
	when "D" then 8
	end
	cut = case cut
	when "F" then 1
	when "G" then 2
	when "VG" then 3
	when "EX" then 4
	end
	fluorescence = case fluorescence
	when "SB" then 1
	when "MB" then 2
	when "F" then 3
	when "N" then 4
	end
	polish = case polish
	when "F" then 1
	when "G" then 2
	when "VG" then 3
	when "EX" then 4
	end
	symmetry = case symmetry
	when "F" then 1
	when "G" then 2
	when "VG" then 3
	when "EX" then 4
	end
#	prices = prices.to_f * carat.to_f * er
#	prices = prices.to_i
	#print c_number,carat,color,clarity,cut,polish,symmetry,fluorescence,prices,s_prices	
	#print "#{prices}\t#{s_prices.class}\n"
	insert_row = ['0',c_number,carat,color,clarity,cut,polish,symmetry,fluorescence,prices,s_prices]
	with_db do |db|
	#print "insert into dmd(a,b,c,d,e,f,g,h,h,i,j) values(#{row.map{|y|"'#{y}'"}.join(',')})\n"
	db.query("insert into #{$table}(number,c_number,carat,color,clarity,cut,polish,symmetry,fluorescence,prices,s_prices) values(#{insert_row.map{|y|"'#{y}'"}.join(',')})")
	#db.query("insert into #{$table}(number,c_number,carat,color,clarity,cut,polish,symmetry,fluorescence,prices,s_prices) values('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s')" %row)
	end
end 
#	$logger.info "insert er=#{er}"


