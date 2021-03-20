ractor = Ractor.new do
  message = Ractor.receive
  puts "Message received #{message}"
end

ractor.send("Hello from the other side")
