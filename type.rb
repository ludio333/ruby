#!/usr/bin/env ruby
#
#
a=[1,33," abc     ",3.14]

a.collect!{|x|
puts x.class
if x.is_a?String
x.strip!
elsif x.is_a?Float
x.to_i
else
x
end
}

p a
