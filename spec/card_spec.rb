require 'spec_helper'
require_relative '../poker_hand.rb'

describe Card do
  let(:card) { Card.new(value: 'T', suit: 'C') }

  it "converts letter value to integer" do
    expect(card.digit_value).to be_integer
  end

  it { expect(Card.new(value: 'T', suit: 'C').digit_value).to eq 10 }
  it { expect(Card.new(value: 'J', suit: 'C').digit_value).to eq 11 }
  it { expect(Card.new(value: 'Q', suit: 'C').digit_value).to eq 12 }
  it { expect(Card.new(value: 'K', suit: 'C').digit_value).to eq 13 }
  it { expect(Card.new(value: 'A', suit: 'C').digit_value).to eq 14 }
end
