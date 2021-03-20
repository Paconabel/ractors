class Service

  def initialize
    @amount = 0
    # @instance_lock = Mutex.new
  end

  def get_amount
    @amount
  end

  def set_amount(amount)
    @amount = amount
  end

  def increment(i)
    # @instance_lock.synchronize do
      p i
      @amount += 1
      p self.object_id, "id"
    # end
  end
end

MAX_WORKERS = 10

service = Service.new
p Ractor.shareable?(service), "***"
workers = MAX_WORKERS.times.map do |i|
  Ractor.new(service, i) do |svc, i|
    svc.increment(i)
    # svc.set_amount(svc.get_amount + 1)
  end
end

until workers.empty?
  r, v = Ractor.select(*workers)
  workers.delete r
  p answer: v
end
