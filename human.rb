require_relative 'stack'
require_relative 'player'

class Human < Player
    attr_reader :cards, :name

    def turn_prep
        super
    end

    def place_card_phase
    end

    def draw_card_phase
    end

end
