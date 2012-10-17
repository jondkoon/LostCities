class Stack
    attr_reader :cards

    def initialize(suit)
        @cards = []
        @suit = suit
    end

    public
    def draw_card
        @cards.pop
    end

    def place_card(card)
        if card.suit == @suit 
            @cards.push card
        else 
            raise "only cards with suit #{@suit} can be placed on this stack"
        end
    end

    def to_s
        @cards.each do |card|
            puts card
        end
    end
end
