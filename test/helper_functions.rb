require_relative 'test_helper'
require 'Chessington/engine'

module HelperFunctions
  module SweepingPieceHelperFunctions
    include Chessington::Engine

    def get_straight_moves(current_square, range)
      moves = []
      (1..range).each do |i|
        [
          current_square.copy.add(i, 0),
          current_square.copy.add(-i, 0),
          current_square.copy.add(0, i),
          current_square.copy.add(0, -i)
        ].each { |square| moves << square if Board.is_valid_square?(square) }
      end
      moves
    end

    def get_diagonal_moves(current_square, range)
      moves = []
      (1..range).each do |i|
        [
          current_square.copy.add(i, i),
          current_square.copy.add(-i, i),
          current_square.copy.add(i, -i),
          current_square.copy.add(-i, -i)
        ].each { |square| moves << square if Board.is_valid_square?(square) }
      end
      moves
    end

    def get_straight_and_diagonal_moves(current_square, range)
      get_straight_moves(current_square, range) + get_diagonal_moves(current_square, range)
    end

    def blocked_test(piece, piece_square, pawn_player, pawn_square, blocked_squares, move_squares, num_expected_moves)
      # Arrange
      pawn = Pawn.new(pawn_player)
      board = Board.empty
      board.set_piece(piece_square, piece)
      board.set_piece(pawn_square, pawn)

      # Act
      moves = piece.available_moves(board)

      # Assert
      # Check blocked squares are NOT included
      blocked_squares.each { |square| refute_includes(moves, square) }
      # Check all moves EXCEPT to own square and blocked are included
      move_squares.each { |square| assert_includes(moves, square) unless blocked_squares.include?(square) }
      # Assert no other moves included
      assert_equal(num_expected_moves, moves.length)
    end
  end
end
