class Deck
    attr_reader :cards
    def initialize
        @cards = []
        suits = [:spade, :heart, :club, :diamond, :hash]
        suits.each do |suit|
            (2..10).each do |rank| 
                @cards.push(Card.new(suit,rank))
            end
            3.times { @cards.push(Card.new(suit,0)) }
        end
    end

    public
    def draw_card
        @cards.delete_at(rand(@cards.length))
    end

    def draw_cards(number)
        cards = []
        number.times { cards.push(draw_card) }
        return cards
    end

    def size
        @cards.size
    end

    def to_s
        @cards.each do |card|
            puts card
        end
    end
end
