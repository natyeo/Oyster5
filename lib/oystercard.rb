class Oystercard
  
  MAX_BALANCE = 90
  
  attr_reader :balance

  def initialize
    @balance = 0
  end

  def top_up(amount)
    raise "Cannot top up, balance will exceed #{MAX_BALANCE} Pounds" if @balance + amount > MAX_BALANCE
    @balance += amount
  end

end