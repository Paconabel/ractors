ractor = Ractor.new do
  Ractor.yield 42
end

message = ractor.take

puts "Message taken: #{message}"
