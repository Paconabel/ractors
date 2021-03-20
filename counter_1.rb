# rubocop:disable all

class Counter
  def initialize
    @amount = 0
  end

  def increment(i)
    @amount += 1
  end
end

MAX_WORKERS = 10

counter = Counter.new
workers = MAX_WORKERS.times.map do |i|
  Ractor.new(counter, i) do |svc, i|
    svc.increment(i)
  end
end

until workers.empty?
  r, v = Ractor.select(*workers)
  workers.delete r
  p count: v
end
