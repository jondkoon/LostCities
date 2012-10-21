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

    def size
        @cards.size
    end

    def to_s
        @cards
    end
end

class ExpeditionStack < Stack

    alias :super_place_card :place_card

    public
    def place_card(card)
        if(card.value > top_value or (top_value == 0 and card.value == 0))
            super_place_card(card)
        else
            puts "Error: tried to place #{card} on #{@cards} with top_value #{top_value}"
            raise "Wrong Value"
        end
    end
    
    def draw_card
        raise "Can't draw card from expedition"
    end

    def score
        return 0 if size == 0
        sum = @cards.reduce(0) {|sum, card| sum + card.value }
        multiplier = 1 + @cards.count {|c| c.value == 0 }
        bonus = @cards.size >= 8 ? 20 : 0
        ((sum - 20) * multiplier) + bonus
    end
end
