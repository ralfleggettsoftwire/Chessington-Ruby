require_relative 'test_helper'
require 'Chessington/engine'

class TestQueen < Minitest::Test
  include Chessington::Engine

  def test_white_knight_can_move_all_directions
    # Arrange
    board = Board.empty
    knight = Knight.new(Player::WHITE)
    knight_square = Square.at(3, 3)
    board.set_piece(knight_square, knight)

    # Act
    moves = knight.available_moves(board)

    # Assert
    assert_includes(moves, Square.at(5, 2))
    assert_includes(moves, Square.at(5, 4))
    assert_includes(moves, Square.at(4, 5))
    assert_includes(moves, Square.at(2, 5))
    assert_includes(moves, Square.at(1, 4))
    assert_includes(moves, Square.at(1, 2))
    assert_includes(moves, Square.at(2, 1))
    assert_includes(moves, Square.at(4, 1))
    assert_equal(8, moves.length)
  end

  def test_black_knight_can_move_all_directions
    # Arrange
    board = Board.empty
    knight = Knight.new(Player::BLACK)
    knight_square = Square.at(3, 3)
    board.set_piece(knight_square, knight)

    # Act
    moves = knight.available_moves(board)

    # Assert
    assert_includes(moves, Square.at(5, 2))
    assert_includes(moves, Square.at(5, 4))
    assert_includes(moves, Square.at(4, 5))
    assert_includes(moves, Square.at(2, 5))
    assert_includes(moves, Square.at(1, 4))
    assert_includes(moves, Square.at(1, 2))
    assert_includes(moves, Square.at(2, 1))
    assert_includes(moves, Square.at(4, 1))
    assert_equal(8, moves.length)
  end

  def test_white_knight_cannot_jump_off_board
    # Arrange
    board = Board.empty
    knight = Knight.new(Player::WHITE)
    knight_square = Square.at(0, 0)
    board.set_piece(knight_square, knight)

    # Act
    moves = knight.available_moves(board)

    # Assert
    assert_includes(moves, Square.at(2, 1))
    assert_includes(moves, Square.at(1, 2))
    assert_equal(2, moves.length)
  end

  def test_black_knight_cannot_jump_off_board
    # Arrange
    board = Board.empty
    knight = Knight.new(Player::BLACK)
    knight_square = Square.at(0, 0)
    board.set_piece(knight_square, knight)

    # Act
    moves = knight.available_moves(board)

    # Assert
    assert_includes(moves, Square.at(2, 1))
    assert_includes(moves, Square.at(1, 2))
    assert_equal(2, moves.length)
  end

  def test_white_knight_can_jump_over_pieces
    # Arrange
    board = Board.empty
    knight = Knight.new(Player::WHITE)
    knight_square = Square.at(0, 0)
    pawn = Pawn.new(Player::WHITE)
    pawn_square = Square.at(1, 0)
    board.set_piece(knight_square, knight)
    board.set_piece(pawn_square, pawn)

    # Act
    moves = knight.available_moves(board)

    # Assert
    assert_includes(moves, Square.at(2, 1))
    assert_includes(moves, Square.at(1, 2))
    assert_equal(2, moves.length)
  end

  def test_black_knight_can_jump_over_pieces
    # Arrange
    board = Board.empty
    knight = Knight.new(Player::BLACK)
    knight_square = Square.at(0, 0)
    pawn = Pawn.new(Player::BLACK)
    pawn_square = Square.at(1, 0)
    board.set_piece(knight_square, knight)
    board.set_piece(pawn_square, pawn)

    # Act
    moves = knight.available_moves(board)

    # Assert
    assert_includes(moves, Square.at(2, 1))
    assert_includes(moves, Square.at(1, 2))
    assert_equal(2, moves.length)
  end

  def test_white_knight_obstructed_by_white_piece
    # Arrange
    board = Board.empty
    knight = Knight.new(Player::WHITE)
    knight_square = Square.at(0, 0)
    pawn = Pawn.new(Player::WHITE)
    pawn_square = Square.at(2, 1)
    board.set_piece(knight_square, knight)
    board.set_piece(pawn_square, pawn)

    # Act
    moves = knight.available_moves(board)

    # Assert
    refute_includes(moves, Square.at(2, 1))
    assert_includes(moves, Square.at(1, 2))
    assert_equal(1, moves.length)
  end

  def test_black_knight_obstructed_by_black_piece
    # Arrange
    board = Board.empty
    knight = Knight.new(Player::BLACK)
    knight_square = Square.at(0, 0)
    pawn = Pawn.new(Player::BLACK)
    pawn_square = Square.at(2, 1)
    board.set_piece(knight_square, knight)
    board.set_piece(pawn_square, pawn)

    # Act
    moves = knight.available_moves(board)

    # Assert
    refute_includes(moves, Square.at(2, 1))
    assert_includes(moves, Square.at(1, 2))
    assert_equal(1, moves.length)
  end

  def test_white_knight_can_take_black_piece
    # Arrange
    board = Board.empty
    knight = Knight.new(Player::WHITE)
    knight_square = Square.at(0, 0)
    pawn = Pawn.new(Player::BLACK)
    pawn_square = Square.at(2, 1)
    board.set_piece(knight_square, knight)
    board.set_piece(pawn_square, pawn)

    # Act
    moves = knight.available_moves(board)

    # Assert
    assert_includes(moves, Square.at(2, 1))
    assert_includes(moves, Square.at(1, 2))
    assert_equal(2, moves.length)
  end

  def test_black_knight_can_take_white_piece
    # Arrange
    board = Board.empty
    knight = Knight.new(Player::BLACK)
    knight_square = Square.at(0, 0)
    pawn = Pawn.new(Player::WHITE)
    pawn_square = Square.at(2, 1)
    board.set_piece(knight_square, knight)
    board.set_piece(pawn_square, pawn)

    # Act
    moves = knight.available_moves(board)

    # Assert
    assert_includes(moves, Square.at(2, 1))
    assert_includes(moves, Square.at(1, 2))
    assert_equal(2, moves.length)
  end
end
