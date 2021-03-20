# rubocop:disable all
require 'httparty'
require_relative './transfer_queue'

total = 0
now = Time.now
TransferQueue.subscribe do |transfer|
  transfer_amount = HTTParty.get("http://localhost:3000/transfer/#{transfer[:id]}")
  total += transfer_amount['amount']
  p transfer.merge(transfer_amount)
end

p total: total, time: Time.now - now
