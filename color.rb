#!/usr/bin/env ruby
require 'rubygems'                       
require 'colorize'                       

def ping_o                              
ips=(1..253)                     
	threads=[]                       
	ips.each { |ip|                  
		threads << Thread.new do
			host = '10.2.0.' + ip.to_s                                                
			Thread.current["result"]=`ping -c 1 -w 1 10.2.0.#{ip}`
			Thread.current["ip"]    = host
	end              
	}                                

	threads.each { |t|               
	t.join                           
		puts t["ip"].colorize(:red)      
		puts t["result"].colorize(:yellow)
}                                
end                                      

while(1)                                 
	ping_o                                   
	sleep 1                                 
end                                      
