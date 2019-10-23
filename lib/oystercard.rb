class Oystercard
  
  MIN_BALANCE = 1
  MAX_BALANCE = 90
  MIN_FARE = 1

  attr_reader :balance
  attr_reader :in_use
  attr_reader :entry_station
  attr_reader :exit_station
  attr_reader :journey_history

  def initialize(balance = 0)
    @balance = balance
    @in_use = false
    @entry_station = nil
    @journey_history = Hash.new
    @exit_station = nil
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
  
  def touch_out(exit_station = "Aldwych")
    deduct_fare(MIN_FARE)
    @exit_station = exit_station
    @in_use = false
    @journey_history = { 
      :origin => @entry_station,
      :destination => @exit_station
    }
    @entry_station = nil
  end

   private

  def deduct_fare(amount)
    @balance -= amount
  end

end
