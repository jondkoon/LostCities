class Stack
    attr_reader :cards, :suit

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

    def top_card
        @cards.last
    end

    def top_value
        @cards.last ? @cards.last.value : -1
    end

    def to_s
        @cards
    end
end

class ExpeditionStack < Stack

    alias :super_place_card :place_card

    def place_card(card)
        if(card.value > top_value)
            super_place_card(card)
        else
            p "Error: tried to place #{card} on #{@cards} with top_value #{top_value}"
            raise "Wrong Value"
        end
    end
    
    def draw_card
    end
end
