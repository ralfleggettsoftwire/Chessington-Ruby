require_relative "test_helper"
require "Chessington/engine"

class TestPieces < Minitest::Test
  class TestPawn < Minitest::Test
    include Chessington::Engine

    def test_white_pawns_can_move_up_one_square

      # Arrange
      board = Board.empty
      pawn = Pawn.new(Player::WHITE)
      square = Square.at(1, 4)
      board.set_piece(square, pawn)

      # Act
      moves = pawn.available_moves(board)

      # Assert
      assert_includes(moves, Square.at(2, 4))
    end

    def test_black_pawns_can_move_down_one_square

      # Arrange
      board = Board.empty
      pawn = Pawn.new(Player::BLACK)
      square = Square.at(6, 4)
      board.set_piece(square, pawn)

      # Act
      moves = pawn.available_moves(board)

      # Assert
      assert_includes(moves, Square.at(5, 4))
    end

    def test_white_pawn_can_move_up_two_squares_if_not_moved

      # Arrange
      board = Board.empty
      pawn = Pawn.new(Player::WHITE)
      square = Square.at(1, 4)
      board.set_piece(square, pawn)

      # Act
      moves = pawn.available_moves(board)

      # Assert
      assert_includes(moves, Square.at(3, 4))
    end

    def test_black_pawn_can_move_down_two_squares_if_not_moved

      # Arrange
      board = Board.empty
      pawn = Pawn.new(Player::BLACK)
      square = Square.at(6, 4)
      board.set_piece(square, pawn)

      # Act
      moves = pawn.available_moves(board)

      # Assert
      assert_includes(moves, Square.at(4, 4))
    end

    def test_white_pawn_cannot_move_up_two_squares_if_already_moved

      # Arrange
      board = Board.empty
      pawn = Pawn.new(Player::WHITE)
      starting_square = Square.at(1, 4)
      board.set_piece(starting_square, pawn)

      intermediate_square = Square.at(2, 4)
      pawn.move_to(board, intermediate_square)

      # Act
      moves = pawn.available_moves(board)

      # Assert
      refute_includes(moves, Square.at(4, 4))

    end

    def test_black_pawn_cannot_move_down_two_squares_if_already_moved

      # Arrange
      board = Board.empty
      pawn = Pawn.new(Player::BLACK)
      starting_square = Square.at(6, 4)
      board.set_piece(starting_square, pawn)

      intermediate_square = Square.at(5, 4)
      pawn.move_to(board, intermediate_square)

      # Act
      moves = pawn.available_moves(board)

      # Assert
      refute_includes(moves, Square.at(3, 4))

    end
  end
end