require_relative 'journey'

class Oystercard
  
  MIN_BALANCE = 1
  MAX_BALANCE = 90
  MIN_FARE = 1

  attr_reader :balance
  attr_reader :in_use
  attr_reader :journey_history
  attr_reader :journey

  def initialize(balance = 0)
    @balance = balance
    @in_use = false
    @journey_history = Array.new
  end

  def top_up(amount)
    raise "Cannot top up, balance will exceed #{MAX_BALANCE} Pounds" if @balance + amount > MAX_BALANCE
    @balance += amount
  end

  def touch_in(entry_station = "Aldgate East")
    raise "Cannot touch in, balance too low" if balance < MIN_BALANCE
    @in_use = true
    @journey = Journey.new
    @journey.start(entry_station)
  end
  
  def touch_out(exit_station = "Aldwych")
    @in_use = false
    @journey.finish(exit_station)
    deduct_fare(@journey.fare)
    @journey_history.push(@journey.current_journey)
  end

   private

  def deduct_fare(amount)
    @balance -= amount
  end

end
