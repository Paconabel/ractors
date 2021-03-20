puts Time.now

TOTAL_COUNT = 5000

queue = Queue.new

TOTAL_COUNT.times do |n|
  queue << n
end

def fact(n)
  (1..n).inject(:*) || 1
end

@result_threads = []
MAX_WORKERS = 500

workers = MAX_WORKERS.times.map do
  Thread.new do
    begin
      while !queue.empty? && n = queue.pop(true)
        @result_threads << fact(n)
      end
    # rescue ThreadError => e
      # p 'Thread Error'
    end
  end
end
workers.each(&:join)

@result_threads.sort!
puts Time.now
