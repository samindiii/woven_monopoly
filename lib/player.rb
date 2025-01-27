#Player class that defines name,money,position and properties
#All players start with $16 and in position 0 (GO) 
class Player
    attr_accessor :name, :money, :position, :properties
    def initialize(name)
        @name = name
        @money = 16
        @position = 0
        @properties = []
    end
end

