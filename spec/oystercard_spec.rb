require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  it 'checks that a new card has a balance of 0' do
    expect(oystercard.balance).to eq 0
  end
  it { is_expected.to respond_to(:top_up).with(1).arguments }
  it 'increments the balance by the amount passed as argument' do
    expect{ subject.top_up(1) }.to change{ subject.balance }.by 1
  end
end