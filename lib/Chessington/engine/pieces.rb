module Chessington
  module Engine
    ##
    # An abstract base class from which all pieces inherit.
    module Piece
      attr_reader :player

      def initialize(player)
        @player = player
      end

      ##
      #  Get all squares that the piece is allowed to move to.
      def available_moves(board)
        raise "Not implemented"
      end

      ##
      # Checks if piece would be obstructed while attempting to move to new_square
      def is_obstructed(board, square, new_square)
        raise "Not implemented"
      end

      ##
      # Move this piece to the given square on the board.
      def move_to(board, new_square)
        current_square = board.find_piece(self)
        board.move_piece(current_square, new_square)
      end

      ##
      # Check if there is a piece at square and if it belongs to the opponent
      def can_take_piece_at?(board, square)
        piece = board.get_piece(square)
        piece && piece.player == @player.opponent
      end
    end

    ##
    # A class representing a chess pawn.
    class Pawn
      include Piece

      def initialize(player)
        super
        @has_moved = false
      end

      def move_to(board, new_square)
        super
        @has_moved = true
      end

      def is_obstructed?(board, square, new_square)
        start_row = square.row + (@player == Player::WHITE ? 1 : -1)
        end_row = new_square.row
        ([start_row, end_row].min..[start_row, end_row].max).any? do |row|
          board.get_piece(Square.at(row, square.column))
        end
      end

      def available_moves(board)
        available_moves = []
        current_square = board.find_piece(self)

        # Move forwards
        new_square = Square.at(
          current_square.row + (@player == Player::WHITE ? 1 : -1),
          current_square.column
        )
        available_moves << new_square unless
          !board.is_valid_square?(new_square) || is_obstructed?(board, current_square, new_square)

        # Move forwards twice if not moved
        new_square = Square.at(
          current_square.row + (@player == Player::WHITE ? 2 : -2),
          current_square.column
        )
        available_moves << new_square unless
          !board.is_valid_square?(new_square) || @has_moved || is_obstructed?(board, current_square, new_square)

        # Check left diagonal for opponent
        new_square = Square.at(
          current_square.row + (@player == Player::WHITE ? 1 : -1),
          current_square.column + (@player == Player::WHITE ? -1 : 1)
        )
        available_moves << new_square if
          board.is_valid_square?(new_square) && can_take_piece_at?(board, new_square)

        # Check right diagonal for opponent
        new_square = Square.at(
          current_square.row + (@player == Player::WHITE ? 1 : -1),
          current_square.column + (@player == Player::WHITE ? 1 : -1)
        )
        available_moves << new_square if
          board.is_valid_square?(new_square) && can_take_piece_at?(board, new_square)

        available_moves
      end
    end

    ##
    # A class representing a chess knight.
    class Knight
      include Piece

      def available_moves(board)
        []
      end
    end

    ##
    # A class representing a chess bishop.
    class Bishop
      include Piece

      def available_moves(board)
        []
      end
    end

    ##
    # A class representing a chess rook.
    class Rook
      include Piece

      def available_moves(board)
        []
      end
    end

    ##
    # A class representing a chess queen.
    class Queen
      include Piece

      def available_moves(board)
        []
      end
    end

    ##
    # A class representing a chess king.
    class King
      include Piece

      def available_moves(board)
        []
      end
    end
  end
end
