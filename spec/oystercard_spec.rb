require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { double(:entry_station) }

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
  
  describe '#touch_out' do
    it 'deducts the fare amount from the oystercard on touch out' do
      expect{ oystercard.touch_out }.to change{ oystercard.balance }.by(-Oystercard::MIN_FARE)
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
end