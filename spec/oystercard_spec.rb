require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { double(:station) }
  let(:exit_station) { double(:station) }
  let(:journey_history) { double(:journey_history) }

  it 'checks that a new card has a balance of 0' do
    expect(oystercard.balance).to eq 0
  end

  it { is_expected.to respond_to(:top_up).with(1).arguments }

  it 'increments the balance by the amount passed as argument' do
    expect{ oystercard.top_up(1) }.to change{ oystercard.balance }.by 1
  end

  it 'raises an error when the maximum balance is exceeded' do
    oystercard.top_up(Oystercard::MAX_BALANCE)
    expect { oystercard.top_up(1) }.to raise_error "Cannot top up, balance will exceed #{Oystercard::MAX_BALANCE} Pounds"
  end

  it 'reduces the balance by the amount passed as argument' do
    expect { oystercard.touch_out }.to change{ oystercard.balance }.by (-Oystercard::MIN_FARE)
  end

  it 'checks that card is not in use' do
    expect(oystercard.entry_station).to eq nil
  end

  context 'Checks minimum balance' do
    before do
      oystercard.top_up(Oystercard::MIN_BALANCE)
    end

    it 'puts card in use' do
      expect{ oystercard.touch_in(:entry_station) }.to change{ oystercard.entry_station }.from(nil).to(:entry_station)
    end

    it 'puts card out of use' do
      oystercard.touch_in(:entry_station)
      expect{ oystercard.touch_out }.to change{ oystercard.entry_station }.from(:entry_station).to(nil)
    end
  end
  
  context 'already in a journey' do
    describe '#touch_out' do
      before do
        oystercard.top_up(Oystercard::MIN_BALANCE)
      end 
      it 'deducts the fare amount from the oystercard on touch out' do
        expect{ oystercard.touch_out }.to change{ oystercard.balance }.by(-Oystercard::MIN_FARE)
      end
      it 'stores exit station' do
        oystercard.touch_in(entry_station)
        oystercard.touch_out(exit_station)
        expect(oystercard.exit_station).to eq exit_station
      end 
    end
  end 


  describe '#touch_in' do
    it 'remembers the entry station on touch in' do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in(:entry_station)
      expect(oystercard.entry_station).to eq (:entry_station)
    end
  end

  it 'checks the minimum balance on touch in' do
    oystercard.balance < Oystercard::MIN_BALANCE
    expect { oystercard.touch_in(:entry_station) }.to raise_error "Cannot touch in, balance too low"
  end

  it 'has an empty list of journeys by default' do
    expect(oystercard.journey_history).to be_empty
  end 

  context 'complete journeys' do
    let(:journey){ {origin: entry_station, destination: exit_station} }
    before do
      oystercard.top_up(Oystercard::MIN_BALANCE)
    end 
    it 'stores a journey' do
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.journey_history).to include journey
    end 
  end 
end