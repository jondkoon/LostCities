class Hand
    include Comparable
    attr_reader :cards

    def initialize(cards)
        @cards = cards || []
    end

    def <=>(other)
        value <=> other.value
    end

    public
    def add_card(card)
        @cards.push(card)
    end

    def to_s
        @cards.join("  ")
    end
end
