require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  it 'checks that a new card has a balance of 0' do
    expect(oystercard.balance).to eq 0
  end
end