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
      def is_obstructed(board, square, new_square, *)
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
      def opponent_piece_at?(board, square)
        piece = board.get_piece(square)
        piece && piece.player == @player.opponent
      end
    end

    ##
    # A class for pieces that sweep across the board in straight and/or diagonal directions for a potentially limited
    # number of squares (e.g. King)
    module SweepingPiece
      def get_moves_in_direction(board, direction, range, current_square)
        moves = []
        new_square = current_square.copy
        (1..range).each do
          new_square = get_next_square_in_direction(new_square, direction)
          if is_unobstructed_valid_square?(board, current_square, new_square, direction)
            moves << new_square
          else
            break
          end
        end
        moves
      end

      ##
      # Note: assumes obstructing piece is always at new_square and not between current_square and new_square. This is
      # fine since in get_moves_in_direction() we add valid squares starting at current_square and moving outwards;
      # if this were used elsewhere we'd have to take care
      def is_unobstructed_valid_square?(board, current_square, new_square, direction)
        is_valid_square = Board.is_valid_square?(new_square)
        if is_valid_square && is_obstructed?(board, current_square, new_square, direction)
          opponent_piece_at?(board, new_square)
        else
          is_valid_square
        end
      end

      def is_obstructed?(board, square, new_square, direction)
        test_square = square.copy
        squares_to_test = []
        until test_square == new_square
          test_square = get_next_square_in_direction(test_square, direction)
          squares_to_test << test_square
        end
        squares_to_test.any? { |sq| board.get_piece(sq) }
      end

      private def get_next_square_in_direction(square, direction)
        new_square = square.copy
        direction.each_char do |d|
          new_square.add(1, 0) if d == "N"
          new_square.add(-1, 0) if d == "S"
          new_square.add(0, 1) if d == "E"
          new_square.add(0, -1) if d == "W"
        end
        new_square
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
        new_square = current_square.copy.add(@player == Player::WHITE ? 1 : -1, 0)
        available_moves << new_square unless
          !Board.is_valid_square?(new_square) || is_obstructed?(board, current_square, new_square)

        # Move forwards twice if not moved
        new_square = current_square.copy.add(@player == Player::WHITE ? 2 : -2, 0)
        available_moves << new_square unless
          !Board.is_valid_square?(new_square) || @has_moved || is_obstructed?(board, current_square, new_square)

        # Check left diagonal for opponent
        new_square = current_square.copy.add(@player == Player::WHITE ? 1 : -1, @player == Player::WHITE ? -1 : 1)
        available_moves << new_square if
          Board.is_valid_square?(new_square) && opponent_piece_at?(board, new_square)

        # Check right diagonal for opponent
        new_square = current_square.copy.add(@player == Player::WHITE ? 1 : -1, @player == Player::WHITE ? 1 : -1)
        available_moves << new_square if
          Board.is_valid_square?(new_square) && opponent_piece_at?(board, new_square)

        available_moves
      end
    end

    ##
    # A class representing a chess knight.
    class Knight
      include Piece

      def is_obstructed?(board, square, new_square, *)
        !opponent_piece_at?(board, new_square) && board.get_piece(new_square)
      end

      def available_moves(board)
        available_moves = []
        current_square = board.find_piece(self)

        [[2, -1], [2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2]].each do |row_add, col_add|
          new_square = current_square.copy.add(row_add, col_add)
          available_moves << new_square if
            Board.is_valid_square?(new_square) && !is_obstructed?(board, current_square, new_square)
        end
        available_moves
      end
    end

    ##
    # A class representing a chess bishop.
    class Bishop
      include Piece
      include SweepingPiece

      def available_moves(board)
        available_moves = []
        current_square = board.find_piece(self)

        ["NE", "NW", "SE", "SW"].each do |dir|
          available_moves += get_moves_in_direction(board, dir, Board.get_board_size, current_square)
        end
        available_moves
      end
    end

    ##
    # A class representing a chess rook.
    class Rook
      include Piece
      include SweepingPiece

      def available_moves(board)
        available_moves = []
        current_square = board.find_piece(self)

        ["N", "S", "E", "W"].each do |dir|
          available_moves += get_moves_in_direction(board, dir, Board.get_board_size, current_square)
        end
        available_moves
      end
    end

    ##
    # A class representing a chess queen.
    class Queen
      include Piece
      include SweepingPiece

      def available_moves(board)
        available_moves = []
        current_square = board.find_piece(self)

        ["NE", "NW", "SE", "SW", "N", "S", "E", "W"].each do |dir|
          available_moves += get_moves_in_direction(board, dir, Board.get_board_size, current_square)
        end
        available_moves
      end
    end

    ##
    # A class representing a chess king.
    class King
      include Piece
      include SweepingPiece

      def available_moves(board)
        available_moves = []
        current_square = board.find_piece(self)

        ["NE", "NW", "SE", "SW", "N", "S", "E", "W"].each do |dir|
          available_moves += get_moves_in_direction(board, dir, 1, current_square)
        end
        available_moves
      end
    end
  end
end
