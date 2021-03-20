require 'benchmark'

def fact(n) = (1..n).inject(:*) || 1
TOTAL_COUNT = 5000
MAX_WORKERS = 5

Benchmark.bmbm do |x|
  x.report("Sequential") do
    @result_seq = TOTAL_COUNT.times.map do |i|
      fact(i)
    end.sort
  end

  x.report("Threads (#{MAX_WORKERS}-workers)") do
    queue = Queue.new
    TOTAL_COUNT.times do |n|
      queue << n # fill up the queue with numbers
    end

    @result_threads = []

    workers = MAX_WORKERS.times.map do
      Thread.new do
        begin
          while n = queue.pop(true) # raises error when queue empty
            @result_threads << fact(n)
          end
        rescue ThreadError
          # queue has been processed, exit thread
        end
      end
    end
    workers.each(&:join)
    @result_threads.sort!
  end

  x.report("Ractors (#{MAX_WORKERS} workers)") do
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
  end

  x.report("Fibers") do
    factorial =
      Fiber.new do
        count = 0
        loop do
          Fiber.yield (1..count).inject(:*)
          count += 1
        end
      end
    @result_fiber = Array.new(TOTAL_COUNT) { factorial.resume }
  end
end


puts "*" * 10
p @result_seq.take(6) # => [1, 1, 2, 6, 24, 120]
p @result_threads.take(6) # => [1, 1, 2, 6, 24, 120]
p @result_ractors.take(6) # => [1, 1, 2, 6, 24, 120]
p @result_fiber.take(6)
p [@result_ractors, @result_threads, @result_ractors, @result_fiber]
    .each_cons(2).map {|a, b| a == b}.all? # => true