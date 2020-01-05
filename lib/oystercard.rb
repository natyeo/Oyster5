require_relative 'journey'

class Oystercard
  MIN_BALANCE = 1
  MAX_BALANCE = 90

  attr_reader :balance, :in_use, :journey_history, :journey

  def initialize
    @balance = 0
    @in_use = false
    @journey_history = []
  end

  def top_up(amount)
    raise "Cannot top up, balance will exceed £#{MAX_BALANCE}" if exceed_max_bal?(amount)

    @balance += amount
  end

  def touch_in(entry_station)
    raise 'Cannot touch in, balance too low' if insufficient_bal?

    @in_use = true
    @journey = Journey.new
    @journey.start(entry_station)
  end

  def touch_out(exit_station)
    @in_use = false
    @journey.finish(exit_station)
    deduct_fare(@journey.fare)
    @journey_history.push(@journey.current_journey)
  end

  private

  def deduct_fare(amount)
    @balance -= amount
  end

  def exceed_max_bal?(amount)
    balance + amount > MAX_BALANCE
  end

  def insufficient_bal?
    balance < MIN_BALANCE
  end
end
