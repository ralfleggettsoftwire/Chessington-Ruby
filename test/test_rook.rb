require_relative 'helper_functions'
require_relative 'test_helper'
require 'Chessington/engine'

class TestRook < Minitest::Test
  include Chessington::Engine
  include HelperFunctions::SweepingPieceHelperFunctions

  def test_white_rook_can_move_all_straight_directions
    # Arrange
    board = Board.empty
    rook = Rook.new(Player::WHITE)
    rook_square = Square.at(3, 3)
    board.set_piece(rook_square, rook)

    # Act
    moves = rook.available_moves(board)

    # Assert
    # Check all horizontal and vertical moves EXCEPT to own square are included
    get_straight_moves(rook_square, Board.get_board_size) do |square|
      assert_includes(moves, square)
    end
    # Assert no other moves included
    assert_equal(14, moves.length)
  end

  def test_black_rook_can_move_all_straight_directions
    # Arrange
    board = Board.empty
    rook = Rook.new(Player::BLACK)
    rook_square = Square.at(3, 3)
    board.set_piece(rook_square, rook)

    # Act
    moves = rook.available_moves(board)

    # Assert
    # Check all horizontal and vertical moves EXCEPT to own square are included
    get_straight_moves(rook_square, Board.get_board_size) do |square|
      assert_includes(moves, square)
    end
    # Assert no other moves included
    assert_equal(14, moves.length)
  end

  def test_white_rook_blocked_by_white_piece
    blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(1, 3), [Square.at(1, 3), Square.at(0, 3)])
    blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(6, 3), [Square.at(6, 3), Square.at(7, 3)])
    blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(3, 1), [Square.at(3, 1), Square.at(3, 0)])
    blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(3, 6), [Square.at(3, 6), Square.at(3, 7)])
  end

  def test_black_rook_blocked_by_black_piece
    blocked_test_wrapper(Player::BLACK, Player::BLACK, Square.at(1, 3), [Square.at(1, 3), Square.at(0, 3)])
    blocked_test_wrapper(Player::BLACK, Player::BLACK, Square.at(6, 3), [Square.at(6, 3), Square.at(7, 3)])
    blocked_test_wrapper(Player::BLACK, Player::BLACK, Square.at(3, 1), [Square.at(3, 1), Square.at(3, 0)])
    blocked_test_wrapper(Player::BLACK, Player::BLACK, Square.at(3, 6), [Square.at(3, 6), Square.at(3, 7)])
  end

  def test_white_rook_blocked_by_black_piece
    blocked_test_wrapper(Player::WHITE, Player::BLACK, Square.at(1, 3), [Square.at(0, 3)])
    blocked_test_wrapper(Player::WHITE, Player::BLACK, Square.at(6, 3), [Square.at(7, 3)])
    blocked_test_wrapper(Player::WHITE, Player::BLACK, Square.at(3, 1), [Square.at(3, 0)])
    blocked_test_wrapper(Player::WHITE, Player::BLACK, Square.at(3, 6), [Square.at(3, 7)])
  end

  def test_black_rook_blocked_by_white_piece
    blocked_test_wrapper(Player::BLACK, Player::WHITE, Square.at(1, 3), [Square.at(0, 3)])
    blocked_test_wrapper(Player::BLACK, Player::WHITE, Square.at(6, 3), [Square.at(7, 3)])
    blocked_test_wrapper(Player::BLACK, Player::WHITE, Square.at(3, 1), [Square.at(3, 0)])
    blocked_test_wrapper(Player::BLACK, Player::WHITE, Square.at(3, 6), [Square.at(3, 7)])
  end

  private def blocked_test_wrapper(rook_player, pawn_player, pawn_square, blocked_squares)
    rook = Rook.new(rook_player)
    rook_square = Square.at(3, 3)
    blocked_test(
      rook,
      rook_square,
      pawn_player,
      pawn_square,
      blocked_squares,
      get_straight_moves(rook_square, Board.get_board_size),
      (rook_player == pawn_player ? 12 : 13)
    )
  end
end
