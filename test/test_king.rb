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

  def test_white_king_can_castle
    # Arrange
    board = Board.empty
    king = King.new(Player::WHITE)
    king_square = Square.at(0, 4)
    rook = Rook.new(Player::WHITE)
    rook_square = Square.at(0, 7)
    board.set_piece(king_square, king)
    board.set_piece(rook_square, rook)

    # Act
    moves = king.available_moves(board)

    # Assert
    assert_includes(moves, Square.at(0, 6))
  end

  def test_black_king_can_castle
    # Arrange
    board = Board.empty
    king = King.new(Player::BLACK)
    king_square = Square.at(7, 4)
    rook = Rook.new(Player::BLACK)
    rook_square = Square.at(7, 0)
    board.set_piece(king_square, king)
    board.set_piece(rook_square, rook)

    # Act
    moves = king.available_moves(board)

    # Assert
    assert_includes(moves, Square.at(7, 2))
  end

  def test_white_king_cannot_castle_if_moved
    # Arrange
    board = Board.empty
    king = King.new(Player::WHITE)
    king_square = Square.at(0, 4)
    rook = Rook.new(Player::WHITE)
    rook_square = Square.at(0, 7)
    board.set_piece(king_square, king)
    board.set_piece(rook_square, rook)

    # Act
    king.move_to(board, Square.at(0, 5))
    board.current_player = Player::WHITE
    king.move_to(board, Square.at(0, 4))
    moves = king.available_moves(board)

    # Assert
    refute_includes(moves, Square.at(0, 6))
  end

  def test_black_king_cannot_castle_if_moved
    # Arrange
    board = Board.empty
    king = King.new(Player::BLACK)
    king_square = Square.at(7, 4)
    rook = Rook.new(Player::BLACK)
    rook_square = Square.at(7, 0)
    board.set_piece(king_square, king)
    board.set_piece(rook_square, rook)
    board.current_player = Player::BLACK

    # Act
    king.move_to(board, Square.at(7, 5))
    board.current_player = Player::BLACK
    king.move_to(board, Square.at(7, 4))
    moves = king.available_moves(board)

    # Assert
    refute_includes(moves, Square.at(7, 2))
  end

  def test_white_king_cannot_castle_if_rook_moved
    # Arrange
    board = Board.empty
    king = King.new(Player::WHITE)
    king_square = Square.at(0, 4)
    rook = Rook.new(Player::WHITE)
    rook_square = Square.at(0, 7)
    board.set_piece(king_square, king)
    board.set_piece(rook_square, rook)

    # Act
    rook.move_to(board, Square.at(0, 6))
    board.current_player = Player::WHITE
    rook.move_to(board, Square.at(0, 7))
    moves = king.available_moves(board)

    # Assert
    refute_includes(moves, Square.at(0, 6))
  end

  def test_black_king_cannot_castle_if_rook_moved
    # Arrange
    board = Board.empty
    king = King.new(Player::BLACK)
    king_square = Square.at(7, 4)
    rook = Rook.new(Player::BLACK)
    rook_square = Square.at(7, 0)
    board.set_piece(king_square, king)
    board.set_piece(rook_square, rook)
    board.current_player = Player::BLACK

    # Act
    rook.move_to(board, Square.at(7, 1))
    board.current_player = Player::BLACK
    rook.move_to(board, Square.at(7, 0))
    moves = king.available_moves(board)

    # Assert
    refute_includes(moves, Square.at(7, 2))
  end

  def test_white_king_cannot_castle_if_blocked
    # Arrange
    board = Board.empty
    king = King.new(Player::WHITE)
    king_square = Square.at(0, 4)
    rook = Rook.new(Player::WHITE)
    rook_square = Square.at(0, 7)
    bishop = Bishop.new(Player::WHITE)
    bishop_square = Square.at(0, 5)
    board.set_piece(king_square, king)
    board.set_piece(rook_square, rook)
    board.set_piece(bishop_square, bishop)

    # Act
    moves = king.available_moves(board)

    # Assert
    refute_includes(moves, Square.at(0, 6))
  end

  def test_black_king_cannot_castle_if_blocked
    # Arrange
    board = Board.empty
    king = King.new(Player::BLACK)
    king_square = Square.at(7, 4)
    rook = Rook.new(Player::BLACK)
    rook_square = Square.at(7, 0)
    bishop = Bishop.new(Player::BLACK)
    bishop_square = Square.at(7, 2)
    board.set_piece(king_square, king)
    board.set_piece(rook_square, rook)
    board.set_piece(bishop_square, bishop)

    # Act
    moves = king.available_moves(board)

    # Assert
    refute_includes(moves, Square.at(7, 2))
  end

  def test_white_king_and_white_rook_moved_by_castling
    # Arrange
    board = Board.empty
    king = King.new(Player::WHITE)
    king_square = Square.at(0, 4)
    rook = Rook.new(Player::WHITE)
    rook_square = Square.at(0, 7)
    board.set_piece(king_square, king)
    board.set_piece(rook_square, rook)

    # Act
    king.move_to(board, Square.at(0, 6))

    # Assert
    assert_instance_of(King, board.get_piece(Square.at(0, 6)))
    assert_instance_of(Rook, board.get_piece(Square.at(0, 5)))
  end

  def test_black_king_and_black_rook_moved_by_castling
    # Arrange
    board = Board.empty
    king = King.new(Player::BLACK)
    king_square = Square.at(7, 4)
    rook = Rook.new(Player::BLACK)
    rook_square = Square.at(7, 0)
    board.set_piece(king_square, king)
    board.set_piece(rook_square, rook)

    # Act
    king.move_to(board, Square.at(7, 2))

    # Assert
    assert_instance_of(King, board.get_piece(Square.at(7, 2)))
    assert_instance_of(Rook, board.get_piece(Square.at(7, 3)))
  end
end
