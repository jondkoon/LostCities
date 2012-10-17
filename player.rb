class Player
    include Comparable
    attr_reader :hand, :name, :dealer

    def initialize(name)
        @name = name
    end

    def <=>(other)
        @hand <=> other.hand
    end

    public
    def draw_cards(deck)
        @hand = Hand.new(deck.draw_cards(8))
    end

    def place_card_phase
    end

    def draw_card_phase
    end

    def to_s
        "#{@name} holds:#{@hand}"
    end
end
