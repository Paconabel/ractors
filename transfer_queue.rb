class TransferQueue
  def self.subscribe(&block)
    1.times.map do |i|
      block.call({ id: "ARA#{rand(1000_000_000..1999_999_999)}" })
    end
  end
end
