class Journey
  
  PENALTY_FARE = 6

  attr_reader :entry_station
  attr_reader :exit_station

  def initialize(entry_station = "", exit_station = "")
    @entry_station = entry_station
    @exit_station = exit_station
  end

  def complete?
    if @entry_station != "" && @exit_station != ""
      true
    end
  end

  def fare
    PENALTY_FARE
  end 

  def finish(station)
    self 
  end 

end
