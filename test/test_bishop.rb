require_relative 'helper_functions'
require_relative 'test_helper'
require 'Chessington/engine'

class TestBishop < Minitest::Test
  include Chessington::Engine
  include HelperFunctions::SweepingPieceHelperFunctions

  def test_white_bishop_can_move_all_diagonal_directions
    # Arrange
    board = Board.empty
    bishop = Bishop.new(Player::WHITE)
    bishop_square = Square.at(3, 3)
    board.set_piece(bishop_square, bishop)

    # Act
    moves = bishop.available_moves(board)

    # Assert
    # Check all horizontal and vertical moves EXCEPT to own square are included
    get_diagonal_moves(bishop_square, Board.get_board_size) do |square|
      assert_includes(moves, square)
    end
    # Assert no other moves included
    assert_equal(13, moves.length)
  end

  def test_black_bishop_can_move_all_diagonal_directions
    # Arrange
    board = Board.empty
    bishop = Bishop.new(Player::BLACK)
    bishop_square = Square.at(3, 3)
    board.set_piece(bishop_square, bishop)

    # Act
    moves = bishop.available_moves(board)

    # Assert
    # Check all horizontal and vertical moves EXCEPT to own square are included
    get_diagonal_moves(bishop_square, Board.get_board_size) do |square|
      assert_includes(moves, square)
    end
    # Assert no other moves included
    assert_equal(13, moves.length)
  end

  def test_white_bishop_blocked_by_white_piece
    blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(6, 6), [Square.at(6, 6), Square.at(7, 7)])
    blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(1, 5), [Square.at(1, 5), Square.at(0, 6)])
    blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(1, 1), [Square.at(1, 1), Square.at(0, 0)])
    blocked_test_wrapper(Player::WHITE, Player::WHITE, Square.at(5, 1), [Square.at(5, 1), Square.at(6, 0)])
  end

  def test_black_bishop_blocked_by_black_piece
    blocked_test_wrapper(Player::BLACK, Player::BLACK, Square.at(6, 6), [Square.at(6, 6), Square.at(7, 7)])
    blocked_test_wrapper(Player::BLACK, Player::BLACK, Square.at(1, 5), [Square.at(1, 5), Square.at(0, 6)])
    blocked_test_wrapper(Player::BLACK, Player::BLACK, Square.at(1, 1), [Square.at(1, 1), Square.at(0, 0)])
    blocked_test_wrapper(Player::BLACK, Player::BLACK, Square.at(5, 1), [Square.at(5, 1), Square.at(6, 0)])
  end

  def test_white_bishop_blocked_by_black_piece
    blocked_test_wrapper(Player::WHITE, Player::BLACK, Square.at(6, 6), [Square.at(7, 7)])
    blocked_test_wrapper(Player::WHITE, Player::BLACK, Square.at(1, 5), [Square.at(0, 6)])
    blocked_test_wrapper(Player::WHITE, Player::BLACK, Square.at(1, 1), [Square.at(0, 0)])
    blocked_test_wrapper(Player::WHITE, Player::BLACK, Square.at(5, 1), [Square.at(6, 0)])
  end

  def test_black_bishop_blocked_by_white_piece
    blocked_test_wrapper(Player::BLACK, Player::WHITE, Square.at(6, 6), [Square.at(7, 7)])
    blocked_test_wrapper(Player::BLACK, Player::WHITE, Square.at(1, 5), [Square.at(0, 6)])
    blocked_test_wrapper(Player::BLACK, Player::WHITE, Square.at(1, 1), [Square.at(0, 0)])
    blocked_test_wrapper(Player::BLACK, Player::WHITE, Square.at(5, 1), [Square.at(6, 0)])
  end

  private def blocked_test_wrapper(bishop_player, pawn_player, pawn_square, blocked_squares)
    bishop = Bishop.new(bishop_player)
    bishop_square = Square.at(3, 3)
    blocked_test(
      bishop,
      bishop_square,
      pawn_player,
      pawn_square,
      blocked_squares,
      get_diagonal_moves(bishop_square, Board.get_board_size),
      (bishop_player == pawn_player ? 11 : 12)
    )
  end
end
