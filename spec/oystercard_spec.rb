require 'oystercard'
require 'journey'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { double(:station) }
  let(:exit_station) { double(:station) }

  it 'checks that a new card has a balance of 0' do
    expect(oystercard.balance).to eq 0
  end

  it { is_expected.to respond_to(:top_up).with(1).arguments }

  it 'increments the balance by the amount passed as argument' do
    expect { oystercard.top_up(1) }.to change { oystercard.balance }.by 1
  end

  it 'raises an error when the maximum balance is exceeded' do
    oystercard.top_up(Oystercard::MAX_BALANCE)
    expect { oystercard.top_up(1) }.to raise_error "Cannot top up, balance will exceed £#{Oystercard::MAX_BALANCE}"
  end

  it 'reduces the balance by the amount passed as argument' do
    journey_double = double :Journey
    allow(journey_double).to receive(:finish) { self }
    allow(journey_double).to receive(:fare) { 1 }
    oystercard.top_up(50)
    oystercard.touch_in(entry_station)
    expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by -1
  end

  it 'checks that card is not in use' do
    expect(oystercard.in_use).to eq false
  end

  context 'Checks minimum balance' do
    before do
      oystercard.top_up(Oystercard::MIN_BALANCE)
    end

    it 'puts card in use' do
      expect { oystercard.touch_in(:entry_station) }.to change { oystercard.in_use }.from(false).to(true)
    end

    it 'puts card out of use' do
      oystercard.touch_in(:entry_station)
      expect { oystercard.touch_out(exit_station) }.to change { oystercard.in_use }.from(true).to(false)
    end
  end

  context 'already in a journey' do
    describe '#touch_out' do
      before do
        oystercard.top_up(Oystercard::MIN_BALANCE)
        oystercard.touch_in(:entry_station)
      end
      it 'deducts the fare amount from the oystercard on touch out' do
        expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by -1
      end
    end
  end

  it 'checks the minimum balance on touch in' do
    message = 'Cannot touch in, balance too low'
    expect { oystercard.touch_in(:entry_station) }.to raise_error message
  end

  it 'has an empty list of journeys by default' do
    expect(oystercard.journey_history).to be_empty
  end

  context 'complete journeys' do
    before do
      oystercard.top_up(Oystercard::MIN_BALANCE)
    end
    it 'stores a journey' do
      journey = { entry: 'Aldgate East', exit: 'Aldwych' }
      oystercard.touch_in('Aldgate East')
      oystercard.touch_out('Aldwych')
      expect(oystercard.journey_history).to include journey
    end
  end
end
