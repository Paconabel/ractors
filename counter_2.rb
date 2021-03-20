# rubocop:disable all

class Counter
  def initialize
    @amount = 0
    @instance_lock = Mutex.new
  end

  def increment(i)
    @instance_lock.synchronize do
      p i: i, object_id: object_id
      @amount += 1
    end
  end
end

MAX_WORKERS = 10

counter = Counter.new
p shareable: Ractor.shareable?(counter)

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
