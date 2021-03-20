# rubocop:disable all

counter = Ractor.new do
  total = 0
  loop do
    Ractor.receive
    Ractor.yield total += 1
  end
end

MAX_WORKERS = 100

workers = MAX_WORKERS.times.map do |i|
  Ractor.new(counter, i, name: i.to_s) do |counter, i|
    sleep_count = rand(0.5..10)
    sleep(sleep_count)
    counter.send '🍌'
    parcial = counter.take
    [parcial, sleep_count]
  end
end

until workers.empty?
  r, v = Ractor.select(*workers)
  workers.delete r
  p parcial: v[0], sleep: v[1], ractor: r.name
end

