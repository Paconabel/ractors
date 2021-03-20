puts Time.now
TOTAL_COUNT = 5000

def fact(n)
  (1..n).inject(:*) || 1
end
@result_seq = TOTAL_COUNT.times.map { |i| fact(i) }.sort
puts Time.now


# puts @result_seq