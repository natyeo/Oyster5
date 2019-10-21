class Oystercard
  
  MAX_BALANCE = 90

  attr_reader :balance
  attr_reader :in_use

  def initialize
    @balance = 0
    @in_use = false
  end

  def top_up(amount)
    raise "Cannot top up, balance will exceed #{MAX_BALANCE} Pounds" if @balance + amount > MAX_BALANCE
    @balance += amount
  end

  def deduct_fare(amount)
    @balance -= amount
  end

  def in_journey?
    return @in_use
  end

  def touch_in
    @in_use = true
  end

  def touch_out
    @in_use = false
  end
end
