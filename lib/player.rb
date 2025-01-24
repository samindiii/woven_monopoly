# Things to consider

# position (where is the player at the moment)
# money: $16, lose money by paying rent(double if owner owns all the colors), buying properties, passing go  :earn money by getting paid rent
# properties (what properties does the player own?? )


class Player
    attr_accessor :name, :money, :position, :properties
    def initialize(name)
        @name = name
        @money = 16
        @position = 0
        @properties = []
    end
end

