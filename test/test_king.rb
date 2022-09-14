require_relative 'helper_functions'
require_relative 'test_helper'
require 'Chessington/engine'

class TestQueen < Minitest::Test
  include Chessington::Engine
  include HelperFunctions::SweepingPieceHelperFunctions

  def test_white_king_can_move_all_directions
    # Arrange
    board = Board.empty
    king = King.new(Player::WHITE)
    king_square = Square.at(3, 3)
    board.set_piece(king_square, king)

    # Act
    moves = king.available_moves(board)

    # Assert
    # Check all horizontal and vertical moves EXCEPT to own square are included
    get_straight_and_diagonal_moves(king_square, 1) do |square|
      assert_includes(moves, square)
    end
    # Assert no other moves included
    assert_equal(8, moves.length)
  end

  def test_black_king_can_move_all_directions
    # Arrange
    board = Board.empty
    king = King.new(Player::BLACK)
    king_square = Square.at(3, 3)
    board.set_piece(king_square, king)

    # Act
    moves = king.available_moves(board)

    # Assert
    # Check all horizontal and vertical moves EXCEPT to own square are included
    get_straight_and_diagonal_moves(king_square, 1) do |square|
      assert_includes(moves, square)
    end
    # Assert no other moves included
    assert_equal(8, moves.length)
  end

  def test_white_king_blocked_by_white_piece
    # Arrange
    board = Board.empty
    king = King.new(Player::WHITE)
    king_square = Square.at(3, 3)
    pawn = Pawn.new(Player::WHITE)
    pawn_square = Square.at(4, 3)
    board.set_piece(king_square, king)
    board.set_piece(pawn_square, pawn)

    # Act
    moves = king.available_moves(board)

    # Assert
    refute_includes(moves, pawn_square)
    # Check all horizontal and vertical moves EXCEPT to own square are included
    get_straight_and_diagonal_moves(king_square, 1) do |square|
      assert_includes(moves, square) unless square == pawn_square
    end
    # Assert no other moves included
    assert_equal(7, moves.length)
  end

  def test_black_king_blocked_by_black_piece
    # Arrange
    board = Board.empty
    king = King.new(Player::BLACK)
    king_square = Square.at(3, 3)
    pawn = Pawn.new(Player::BLACK)
    pawn_square = Square.at(4, 3)
    board.set_piece(king_square, king)
    board.set_piece(pawn_square, pawn)

    # Act
    moves = king.available_moves(board)

    # Assert
    refute_includes(moves, pawn_square)
    # Check all horizontal and vertical moves EXCEPT to own square are included
    get_straight_and_diagonal_moves(king_square, 1) do |square|
      assert_includes(moves, square) unless square == pawn_square
    end
    # Assert no other moves included
    assert_equal(7, moves.length)
  end

  def test_white_king_can_take_black_piece
    # Arrange
    board = Board.empty
    king = King.new(Player::WHITE)
    king_square = Square.at(3, 3)
    pawn = Pawn.new(Player::BLACK)
    pawn_square = Square.at(4, 3)
    board.set_piece(king_square, king)
    board.set_piece(pawn_square, pawn)

    # Act
    moves = king.available_moves(board)

    # Assert
    # Check all horizontal and vertical moves EXCEPT to own square are included
    get_straight_and_diagonal_moves(king_square, 1) do |square|
      assert_includes(moves, square)
    end
    # Assert no other moves included
    assert_equal(8, moves.length)
  end

  def test_black_king_can_take_white_piece
    # Arrange
    board = Board.empty
    king = King.new(Player::BLACK)
    king_square = Square.at(3, 3)
    pawn = Pawn.new(Player::WHITE)
    pawn_square = Square.at(4, 3)
    board.set_piece(king_square, king)
    board.set_piece(pawn_square, pawn)

    # Act
    moves = king.available_moves(board)

    # Assert
    # Check all horizontal and vertical moves EXCEPT to own square are included
    get_straight_and_diagonal_moves(king_square, 1) do |square|
      assert_includes(moves, square)
    end
    # Assert no other moves included
    assert_equal(8, moves.length)
  end
end