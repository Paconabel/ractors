require 'fiber'

puts Time.now

factorial =
Fiber.new do
  count = 0

  loop do
    Fiber.yield (1..count).inject(:*)
    count += 1
  end
end

Array.new(5000) { factorial.resume }

puts Time.now
