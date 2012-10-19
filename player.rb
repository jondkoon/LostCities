require_relative 'stack'

class Player
    attr_reader :cards, :name

    def initialize(name)
        @name = name
        @cards = []
        @expedition_stacks = $suit_characters.keys.map { |suit| ExpeditionStack.new(suit) }
    end

    def place_card_phase
        card = @cards.pop
        discard = @game.discard_stacks.find{|d| d.suit == card.suit }
        discard.place_card card
    end

    def draw_card_phase
        @cards.push @game.deck.draw_card
    end

    def draw_cards(deck)
        @cards = deck.draw_cards(8)
    end

    public
    def start_game(game)
        @game = game
        draw_cards(@game.deck)
    end

    def turn
        place_card_phase
        draw_card_phase
    end

    def to_s
        "#{@name} holds:\n#{@cards.join("  ")}" +
        "\n\nexpedition stacks: #{@expedition_stacks}"
    end
end
