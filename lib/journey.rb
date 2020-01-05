class Journey
  PENALTY_FARE = 6
  MIN_FARE = 1

  attr_reader :entry_station, :exit_station, :current_journey

  def initialize(entry_station = '', exit_station = '')
    @entry_station = entry_station
    @exit_station = exit_station
  end

  def start(station)
    @entry_station = station
    @current_journey = { entry: @entry_station, exit: @exit_station }
  end

  def complete?
    @entry_station != '' && @exit_station != ''
  end

  def fare
    complete? ? MIN_FARE : PENALTY_FARE
  end

  def finish(station)
    @exit_station = station
    @current_journey = { entry: @entry_station, exit: @exit_station }
    self
  end
end
