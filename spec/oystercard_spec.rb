require 'oystercard'
require 'journey'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { double(:station) }
  let(:exit_station) { double(:station) }

  describe '#top_up' do
    it 'increments the balance by the amount passed as argument' do
      expect { oystercard.top_up(1) }.to change { oystercard.balance }.by 1
    end

    it 'raises an error when the maximum balance is exceeded' do
      oystercard.top_up(Oystercard::MAX_BALANCE)
      expect { oystercard.top_up(1) }.to raise_error "Cannot top up, balance will exceed £#{Oystercard::MAX_BALANCE}"
    end
  end

  describe '#touch_in' do
    it 'puts card in use' do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      expect { oystercard.touch_in(entry_station) }.to change { oystercard.in_use }.from(false).to(true)
    end

    it 'raises error if insufficient balance' do
      message = 'Cannot touch in, balance too low'
      expect { oystercard.touch_in(entry_station) }.to raise_error message
    end
  end

  describe '#touch_out' do
    before do
      oystercard.top_up(Oystercard::MIN_BALANCE)
      oystercard.touch_in(entry_station)
    end

    it 'deducts the fare amount from the oystercard on touch out' do
      expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by(-1)
    end

    it 'puts card out of use' do
      oystercard.touch_in(entry_station)
      expect { oystercard.touch_out(exit_station) }.to change { oystercard.in_use }.from(true).to(false)
    end

    it 'stores a journey' do
      oystercard.touch_out(exit_station)
      expect(oystercard.journey_history).to include(entry: entry_station, exit: exit_station)
    end
  end
end
