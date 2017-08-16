require 'spec_helper'
require_relative '../poker_hand.rb'
require 'active_support/inflector'

describe Hand do
  let(:cards) { (1..5).map { |v| Card.new(suit: 'Q', value: v + 4) } }
  let(:hand) { Hand.new(cards: cards) }
  let(:another_cards) { (1..4).map { |v| Card.new(suit: 'S', value: v + 4) }.push(Card.new(suit: 'Q', value: 'T')) }
  let(:second_hand) { Hand.new(cards: another_cards) }

  context '#has_same_suits?' do
    it 'expect the number as an argument' do
      expect { hand.has_same_suits? }.to raise_error(ArgumentError)
    end

    context 'hand has provided number of cards with the same suit' do
      it { expect(hand.has_same_suits?(5)).to be_truthy }
      it { expect(hand.has_same_suits?(5)).to eq 'Q'}
    end

    context 'hand has not provided number of cards with the same suit' do
      it { expect(hand.has_same_suits?(6)).to be_falsey }
      it { expect(hand.has_same_suits?(6)).to be_nil}
    end
  end

  context '#consecutive_values?' do
    context 'card values can be sorted as array of consecutive values' do
      it { expect(hand.consecutive_values?).to be true }
    end

    context 'card values cannot be sorted as array of consecutive values' do
      let(:hand) { Hand.new(cards: cards.take(4).push(Card.new(suit: 'C', value: 'A'))) }

      it { expect(hand.consecutive_values?).to be false }
    end
  end

  context '#highest_card' do
    it 'returns the card' do
      expect(hand.highest_card).to be_a(Card)
    end

    it 'returns the card with the highest value' do
      expect(hand.highest_card.value).to eq 9
    end
  end

  context 'the highest category that fits' do
    context '#winning_category' do
      it 'returns the category object' do
        expect(hand.winning_category).to be_a_kind_of(Category)
      end

      it { expect(hand.winning_category).to be_an_instance_of(StraightFlush) }
      it { expect(second_hand.winning_category).to be_an_instance_of(HighCard) }
    end
  end

  context 'comparison' do
    it 'allows to compare two hands' do
      expect{ hand > second_hand }.not_to raise_error
      expect{ hand < second_hand }.not_to raise_error
      expect{ hand == second_hand }.not_to raise_error
    end

    it 'returns boolean' do
      expect(hand > second_hand).to be(true).or be(false)
    end

    context '#compare' do
      it { expect(hand.compare(second_hand)).to be_an(Integer) }
      it { expect(hand.compare(second_hand)).to eq 1 }
      it { expect(second_hand.compare(hand)).to eq -1 }
      it { expect(hand.compare(hand)).to eq 0 }
    end

    context 'hands are within the same category' do
      let(:another_cards) { (1..5).map { |v| Card.new(suit: 'Q', value: v + 2) } }
      let(:second_hand) { Hand.new(cards: another_cards) }

      it { expect(hand.winning_category.to_sym == second_hand.winning_category.to_sym).to be true }

      it 'compares by the highest card' do
        expect(hand.highest_card.digit_value > second_hand.highest_card.digit_value)
        expect(hand.compare(second_hand)).to eq 1
      end
    end
  end
end
