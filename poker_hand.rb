class Card
  attr_reader :suit, :value, :digit_value

  CONVERT_VALUES = { '1' => 1, '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7, '8' => 8, '9' => 9, 'T' => 10, 'J' => 11, 'Q' => 12, 'K' => 13, 'A' => 14 }

  def initialize(suit:, value:)
    @suit = suit
    @value = value
    @digit_value = CONVERT_VALUES[value.to_s]
  end

  def rank
    value
  end

  def to_s
    puts "#{value}#{suit}"
  end
end

class Hand
  include Comparable

  attr_reader :cards

  def initialize(cards:)
    @cards = cards
  end

  def has_same_suits?(num)
    group_by_suit.key(num)
  end

  def consecutive_values?
    sorted_values.each_cons(2).all? {|a, b| b == a + 1 }
  end

  def highest_card
    cards.sort_by { |card| card.digit_value }.last
  end

  def winning_category
    @winning_category ||= CategoryCollection.new(self).winning_category
  end

  def rank
    winning_category.rank
  end

  def <=>(another_hand)
    winning_category <=> another_hand.winning_category
  end

  def compare(another_hand)
    self <=> (another_hand)
  end

  private

  def pluck(attr)
    cards.map(&attr.to_sym)
  end

  def sorted_values
    pluck(:digit_value).sort
  end

  def group_by_suit
    cards.inject(Hash.new(0)) { |h, c| h[[c.suit]] += 1 ; h }
  end

  def group_by_value
    cards.inject(Hash.new(0)) { |h, c| h[[c.value]] += 1 ; h }
  end
end

class Category
  include Comparable

  attr_reader :hand

  def initialize(hand)
    @hand = hand
  end

  def rank
    hand.highest_card.rank
  end

  def to_sym
   self.class.name.underscore.to_sym
  end

  def <=>(another_category)
    comparison = CategoryCollection::CATEGORY_ORDER.index(to_sym) <=>
    CategoryCollection::CATEGORY_ORDER.index(another_category.to_sym)
    comparison.zero? ? rank <=> another_category.rank : comparison
  end
end

class StraightFlush < Category

  def satisfy
    hand.has_same_suits?(5) && hand.consecutive_values?
  end
end

class HighCard < Category
  def satisfy
    true
  end
end

class CategoryCollection
  attr_reader :hand

  CATEGORY_ORDER = [:straight_flush, :high_card]

  def initialize(hand)
    @hand = hand
  end

  def winning_category
    CATEGORY_ORDER.map { |name| name.to_s.classify.constantize.send(:new, hand) }.find do |category|
      category.satisfy
    end
  end
end
