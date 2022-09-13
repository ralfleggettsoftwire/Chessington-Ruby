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

      def is_obstructed?(board, square, new_square)
        rows = [square.row, new_square.row]
        cols = [square.column, new_square.column]
        (rows.min..rows.max).any? do |row|
          (cols.min..cols.max).any? do |col|
            test_square = Square.at(row, col)
            next if test_square == square
            board.get_piece(test_square)
          end
        end
      end

      def available_moves(board)
        # Lambda function to check if a move is valid
        move_is_valid = lambda do |board, current_square, new_square|
          # Check if square is valid first or is_obstructed? will raise an error
          is_valid_square = board.is_valid_square?(new_square)
          if is_valid_square && is_obstructed?(board, current_square, new_square)
            # If we're obstructed, the obstructing piece is at new_square and it belongs to the opponent then valid
            new_square_piece = board.get_piece(new_square)
            new_square_piece && new_square_piece.player != @player
          else
            is_valid_square
          end
        end

        available_moves = []
        current_square = board.find_piece(self)

        (1...Board.get_board_size).each do |i|
          new_square = Square.at(current_square.row - i, current_square.column - i)
          available_moves << new_square if move_is_valid.call(board, current_square, new_square)

          new_square = Square.at(current_square.row - i, current_square.column + i)
          available_moves << new_square if move_is_valid.call(board, current_square, new_square)

          new_square = Square.at(current_square.row + i, current_square.column - i)
          available_moves << new_square if move_is_valid.call(board, current_square, new_square)

          new_square = Square.at(current_square.row + i, current_square.column + i)
          available_moves << new_square if move_is_valid.call(board, current_square, new_square)
        end

        available_moves
      end
    end

    ##
    # A class representing a chess rook.
    class Rook
      include Piece

      def is_obstructed?(board, square, new_square)
        if square.row == new_square.row
          # Moving horizontally
          ([square.column, new_square.column].min..[square.column, new_square.column].max).any? do |col|
            col != square.column && board.get_piece(Square.at(square.row, col))
          end
        else
          # Moving vertically
          ([square.row, new_square.row].min..[square.row, new_square.row].max).any? do |row|
            row != square.row && board.get_piece(Square.at(row, square.column))
          end
        end
      end

      def available_moves(board)
        available_moves = []
        current_square = board.find_piece(self)

        # Add moves vertically
        (0...Board.get_board_size).each do |row|
          next if row == current_square.row
          new_square = Square.at(row, current_square.column)
          if is_obstructed?(board, current_square, new_square)
            # If we're obstructed, the obstructing piece is at new_square and it belongs to the opponent, add to
            # available_moves
            new_square_piece = board.get_piece(new_square)
            available_moves << new_square if new_square_piece && new_square_piece.player != @player
          else
            available_moves << new_square
          end
        end

        # Add moves horizontally
        (0...Board.get_board_size).each do |col|
          next if col == current_square.column
          new_square = Square.at(current_square.row, col)
          if is_obstructed?(board, current_square, new_square)
            # If we're obstructed, the obstructing piece is at new_square and it belongs to the opponent, add to
            # available_moves
            new_square_piece = board.get_piece(new_square)
            available_moves << new_square if new_square_piece && new_square_piece.player != @player
          else
            available_moves << new_square
          end
        end

        available_moves
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
