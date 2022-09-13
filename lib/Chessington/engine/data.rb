module Chessington
  module Engine
    ##
    # The two players in a game of chess.
    Player = Struct.new(:colour) do
      self::WHITE = new(:white)
      self::BLACK = new(:black)

      def opponent
        if colour == :black
          Player::WHITE
        else
          Player::BLACK
        end
      end
      private_class_method :new
    end

    Square = Struct.new(:row, :column) do
      class << self
        alias_method :at,:new

        def ==(other)
          self.row == other.row && self.column == other.column
        end
      end
    end
  end
end
