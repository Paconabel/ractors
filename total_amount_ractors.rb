# rubocop:disable all
require 'io/console'
require 'faraday'

require_relative './transfer_queue'

pipe = Ractor.new do
  loop do
    Ractor.yield Ractor.receive
  end
end

# p Ractor.shareable?(faraday)
# wrapper = Ractor::Wrapper.new(faraday)

WORKER_COUNT = 10
workers = (1..WORKER_COUNT).map do
  Ractor.new pipe do |pipe|
    while transfer_id = pipe.take
      faraday = Ractor.make_shareable(Faraday.new 'http://localhost:3000')
      transfer_amount = faraday.get("/transfer/#{transfer_id}")
      p transfer_amount: transfer_amount
      Ractor.yield transfer_amount.merge(id: transfer_id)
    end
  end
end

# (1..N).each{|i|
#   pipe << i
# }

# pp (1..N).map{
#   _r, (n, b) = Ractor.select(*workers)
#   [n, b]
# }.sort_by{|(n, b)| n}


# total = 0
# now = Time.now
TransferQueue.subscribe do |transfer|
  pipe << transfer[:id]
  # transfer_amount = HTTParty.get("http://localhost:3000/transfer/#{transfer[:id]}")
  # total += transfer_amount['amount']
  # p transfer.merge(transfer_amount)
end

# p total: total, time: Time.now - now

print "\nPress any key..."
STDIN.getch
print "\n"
