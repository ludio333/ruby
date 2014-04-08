#!/usr/bin/env ruby
#

l1 = []
l2 = []
File.open("/root/ssh/rr.list","r") do |file|                                                                                                                            
file.each{|x|
	l1 << x
}
end
File.open("/root/ssh/ip_list","r") do |file|                                                                                                                            
file.each{|x|
	l2 << x
}
end
f= l1 - l2
puts f
