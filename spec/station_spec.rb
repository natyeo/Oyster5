require 'station'

describe Station do
  let(:name) { double(:name) }
  let(:zone) { double(:zone) }
  it 'is a station with a name and a zone' do
    station = Station.new(name, zone)
    expect(station).to be_an_instance_of Station
  end 
end 