require_relative 'helper_functions'
require_relative 'test_helper'
require 'Chessington/engine'

class TestQueen < Minitest::Test
  include Chessington::Engine
  include HelperFunctions::SweepingPieceHelperFunctions

  def test_white_queen_can_move_all_directions
    # Arrange
    board = Board.empty
    queen = Queen.new(Player::WHITE)
    queen_square = Square.at(3, 3)
    board.set_piece(queen_square, queen)

    # Act
    moves = queen.available_moves(board)

    # Assert
    # Check all horizontal and vertical moves EXCEPT to own square are included
    get_straight_and_diagonal_moves(queen_square, Board.get_board_size) do |square|
      assert_includes(moves, square)
    end
    # Assert no other moves included
    assert_equal(27, moves.length)
  end

  def test_black_queen_can_move_all_directions
    # Arrange
    board = Board.empty
    queen = Queen.new(Player::BLACK)
    queen_square = Square.at(3, 3)
    board.set_piece(queen_square, queen)

    # Act
    moves = queen.available_moves(board)

    # Assert
    # Check all horizontal and vertical moves EXCEPT to own square are included
    get_straight_and_diagonal_moves(queen_square, Board.get_board_size) do |square|
      assert_includes(moves, square)
    end
    # Assert no other moves included
    assert_equal(27, moves.length)
  end

  def test_white_queen_blocked_by_white_piece_13
    blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(1, 3), [Square.at(1, 3), Square.at(0, 3)])
    # blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(6, 3), [Square.at(6, 3), Square.at(7, 3)])
    # blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(3, 1), [Square.at(3, 1), Square.at(3, 0)])
    # blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(3, 6), [Square.at(3, 6), Square.at(3, 7)])
    # blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(6, 6), [Square.at(6, 6), Square.at(7, 7)])
    # blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(1, 5), [Square.at(1, 5), Square.at(0, 6)])
    # blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(1, 1), [Square.at(1, 1), Square.at(0, 0)])
    # blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(5, 1), [Square.at(5, 1), Square.at(6, 0)])
  end

  def test_white_queen_blocked_by_white_piece_63
    blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(6, 3), [Square.at(6, 3), Square.at(7, 3)])
  end

  def test_white_queen_blocked_by_white_piece_31
    blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(3, 1), [Square.at(3, 1), Square.at(3, 0)])
  end

  def test_white_queen_blocked_by_white_piece_36
    blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(3, 6), [Square.at(3, 6), Square.at(3, 7)])
  end

  def test_white_queen_blocked_by_white_piece_66
    blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(6, 6), [Square.at(6, 6), Square.at(7, 7)])
  end

  def test_white_queen_blocked_by_white_piece_15
    blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(1, 5), [Square.at(1, 5), Square.at(0, 6)])
  end

  def test_white_queen_blocked_by_white_piece_11
    blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(1, 1), [Square.at(1, 1), Square.at(0, 0)])
  end

  def test_white_queen_blocked_by_white_piece_51
    blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(5, 1), [Square.at(5, 1), Square.at(6, 0)])
  end

  def test_black_queen_blocked_by_black_piece
    blocked_test_wrapper(Player::BLACK, Player::BLACK, Square.at(1, 3), [Square.at(1, 3), Square.at(0, 3)])
    blocked_test_wrapper(Player::BLACK, Player::BLACK, Square.at(6, 3), [Square.at(6, 3), Square.at(7, 3)])
    blocked_test_wrapper(Player::BLACK, Player::BLACK, Square.at(3, 1), [Square.at(3, 1), Square.at(3, 0)])
    blocked_test_wrapper(Player::BLACK, Player::BLACK, Square.at(3, 6), [Square.at(3, 6), Square.at(3, 7)])
    blocked_test_wrapper(Player::BLACK, Player::BLACK, Square.at(6, 6), [Square.at(6, 6), Square.at(7, 7)])
    blocked_test_wrapper(Player::BLACK, Player::BLACK, Square.at(1, 5), [Square.at(1, 5), Square.at(0, 6)])
    blocked_test_wrapper(Player::BLACK, Player::BLACK, Square.at(1, 1), [Square.at(1, 1), Square.at(0, 0)])
    blocked_test_wrapper(Player::BLACK, Player::BLACK, Square.at(5, 1), [Square.at(5, 1), Square.at(6, 0)])
  end

  def test_white_queen_blocked_by_black_piece
    blocked_test_wrapper(Player::WHITE, Player::BLACK, Square.at(1, 3), [Square.at(0, 3)])
    blocked_test_wrapper(Player::WHITE, Player::BLACK, Square.at(6, 3), [Square.at(7, 3)])
    blocked_test_wrapper(Player::WHITE, Player::BLACK, Square.at(3, 1), [Square.at(3, 0)])
    blocked_test_wrapper(Player::WHITE, Player::BLACK, Square.at(3, 6), [Square.at(3, 7)])
    blocked_test_wrapper(Player::WHITE, Player::BLACK, Square.at(6, 6), [Square.at(7, 7)])
    blocked_test_wrapper(Player::WHITE, Player::BLACK, Square.at(1, 5), [Square.at(0, 6)])
    blocked_test_wrapper(Player::WHITE, Player::BLACK, Square.at(1, 1), [Square.at(0, 0)])
    blocked_test_wrapper(Player::WHITE, Player::BLACK, Square.at(5, 1), [Square.at(6, 0)])
  end

  def test_black_queen_blocked_by_white_piece
    blocked_test_wrapper(Player::BLACK, Player::WHITE, Square.at(1, 3), [Square.at(0, 3)])
    blocked_test_wrapper(Player::BLACK, Player::WHITE, Square.at(6, 3), [Square.at(7, 3)])
    blocked_test_wrapper(Player::BLACK, Player::WHITE, Square.at(3, 1), [Square.at(3, 0)])
    blocked_test_wrapper(Player::BLACK, Player::WHITE, Square.at(3, 6), [Square.at(3, 7)])
    blocked_test_wrapper(Player::BLACK, Player::WHITE, Square.at(6, 6), [Square.at(7, 7)])
    blocked_test_wrapper(Player::BLACK, Player::WHITE, Square.at(1, 5), [Square.at(0, 6)])
    blocked_test_wrapper(Player::BLACK, Player::WHITE, Square.at(1, 1), [Square.at(0, 0)])
    blocked_test_wrapper(Player::BLACK, Player::WHITE, Square.at(5, 1), [Square.at(6, 0)])
    end

  private def blocked_test_wrapper(queen_player, pawn_player, pawn_square, blocked_squares)
    queen = Queen.new(queen_player)
    queen_square = Square.at(3, 3)
    blocked_test(
      queen,
      queen_square,
      pawn_player,
      pawn_square,
      blocked_squares,
      get_straight_and_diagonal_moves(queen_square, Board.get_board_size),
      (queen_player == pawn_player ? 25 : 26)
    )
  end
end