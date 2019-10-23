class Oystercard
  
  MIN_BALANCE = 1
  MAX_BALANCE = 90
  MIN_FARE = 1

  attr_reader :balance
  attr_reader :in_use
  attr_reader :entry_station

  def initialize(balance = 0)
    @balance = balance
    @in_use = false
    @entry_station = nil
  end

  def top_up(amount)
    raise "Cannot top up, balance will exceed #{MAX_BALANCE} Pounds" if @balance + amount > MAX_BALANCE
    @balance += amount
  end

  def touch_in(entry_station = "Aldgate East")
    raise "Cannot touch in, balance too low" if balance < MIN_BALANCE
    @in_use = true
    @entry_station = entry_station
  end
  
  def touch_out
    deduct_fare(MIN_FARE)
    @in_use = false
    @entry_station = nil
  end

   private

  def deduct_fare(amount)
    @balance -= amount
  end

end
