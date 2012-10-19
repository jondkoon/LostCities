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
            raise "Wrong Suit"
        end
    end

    def to_s
        @cards.each do |card|
            puts card
        end
    end
end

class ExpeditionStack < Stack

    alias :super_place_card :place_card

    def place_card(card)
        if(card > @cards.last)
            super_place_card(card)
        else
            raise "Wrong Value"
        end
    end
    
    def draw_card
    end

end
