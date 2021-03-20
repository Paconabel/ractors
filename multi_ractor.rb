puts Time.now

TOTAL_COUNT = 5000

MAX_WORKERS = 1000


def fact(n)
  (1..n).inject(:*) || 1
end


workers = []

workers = MAX_WORKERS.times.map do
  Ractor.new do
    while n = Ractor.receive
      Ractor.yield fact(n)
    end
  end
end

TOTAL_COUNT.times do |n|
  workers[n % MAX_WORKERS].send(n)
end

@result_ractors = TOTAL_COUNT.times.map do
  _r, result = Ractor.select(*workers)
  result
end.sort

puts Time.now
