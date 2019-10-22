require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }

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
    expect(oystercard.in_journey?).to eq false
  end

  context 'Checks minimum balance' do
    before do
      expect(oystercard.balance).to be > Oystercard::MIN_BALANCE

      it 'puts card in use' do
        expect{ oystercard.touch_in }.to change{ oystercard.in_journey? }.from(false).to(true)
      end

      it 'puts card out of use' do
        oystercard.touch_in
        expect{ oystercard.touch_out }.to change{ oystercard.in_journey? }.from(true).to(false)
      end
    end
  end
  
  describe '#touch_out' do
    it 'deducts the fare amount from the oystercard on touch out' do
      expect{ oystercard.touch_out }.to change{ oystercard.balance }.by(-Oystercard::MIN_FARE)
    end
  end

  it 'checks the minimum balance on touch in' do
    oystercard.balance < Oystercard::MIN_BALANCE
    expect { oystercard.touch_in }.to raise_error "Cannot touch in, balance too low"
  end
end