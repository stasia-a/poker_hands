The code relies on ActiveSupport::Inflector so best to run within rails console.

Some test data:

`hand1 = Hand.new(cards: [Card.new(suit: 'C', value: '9'), Card.new(suit: 'C', value: 'A'),Card.new(suit: 'C', value: '8'), Card.new(suit: 'C', value: 'T'), Card.new(suit: 'C', value: '7')]);`

`hand2 = Hand.new(cards: [Card.new(suit: 'C', value: '8'), Card.new(suit: 'C', value: '3'),Card.new(suit: 'C', value: 'J'), Card.new(suit: 'C', value: 'T'), Card.new(suit: 'C', value: '7')]);`

`hand3 = Hand.new(cards: [Card.new(suit: 'C', value: '8'), Card.new(suit: 'C', value: '7'),Card.new(suit: 'C', value: 'J'), Card.new(suit: 'C', value: 'T'), Card.new(suit: 'C', value: '9')]);`

`hand1.compare(hand2)`
`hand1.winning_category.to_sym`
`hand1.compare(hand3)`
`hand3.winning_category.to_sym`
