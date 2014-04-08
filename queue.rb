require 'thread'

PI = Math.atan2(0.0, -1.0)
queue = Queue.new

producer = Thread.new do
  128.times do |i|
    queue << 123579 
    puts "#{i} produced"
  end
end

consumer = Thread.new do
  128.times do |i|
    value = queue.pop
    
    value = value / PI
    puts "consumed #{value}"
  end
end

consumer.join

puts PI
