require_relative 'stack'
require_relative 'player'

class Human < Player
    attr_reader :cards, :name

    def turn_prep
        super
    end

    def place_card_phase
       printCards
       choice = ""
       begin
       print "Choose discard(d) or place(p) and a card (1-8): "
       choice = gets.chomp
       end while not choice.match(/[dDpP][1-8]/)

       do_discard = choice[0].match(/[dD]/)
       card = @cards[choice[1].to_i - 1]
       if do_discard 
           puts "discarding #{card}"
           discard card
       else
           puts "placing #{card}"
           place_card card
       end
    end

    def draw_card_phase
        choice = ""
        begin
            print "Draw from deck(y/n)? "
            choice = gets.chomp
            puts choice
        end while not choice.match(/[yYnN]/)
        
        if choice.match(/[yY]/)
            drew = @game.deck.draw_card
        else
            begin
                printDiscard
                print "Choose a discard stack: "
                choice = gets.chomp
            end while not choice.match(/[1-5]/)
            drew = @game.discard_stacks[choice.to_i].draw_card
        end
        @cards.push drew
    end

    #Helpers

    def printCards
        puts "\n" + @cards.join("\t")
        puts (1..8).to_a.join("\t")
    end

    def printDiscard
        i = 1
        @game.discard_stacks.each do |stack|
            puts "#{i}] #{stack.cards.join(" ")}"
            i += 1
        end
    end
end
