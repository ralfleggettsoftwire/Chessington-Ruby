require_relative 'test_helper'
require 'Chessington/engine'

class TestRook < Minitest::Test
  include Chessington::Engine

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
    (0...Board.get_board_size).each do |i|
      assert_includes(moves, Square.at(i, 3)) if i != 3
      assert_includes(moves, Square.at(3, i)) if i != 3
    end
    # Assert no other moves included
    assert_equal(moves.length, 14)
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
    (0...Board.get_board_size).each do |i|
      assert_includes(moves, Square.at(i, 3)) if i != 3
      assert_includes(moves, Square.at(3, i)) if i != 3
    end
    # Assert no other moves included
    assert_equal(moves.length, 14)
  end

  def test_white_rook_blocked_by_white_piece_below
    blocked_test(Player::WHITE, Player::WHITE, 1, 3, [Square.at(1, 3), Square.at(0, 3)])
  end

  def test_black_rook_blocked_by_black_piece_below
    blocked_test(Player::BLACK, Player::BLACK, 1, 3, [Square.at(1, 3), Square.at(0, 3)])
  end

  def test_white_rook_blocked_by_white_piece_above
    blocked_test(Player::WHITE, Player::WHITE, 6, 3, [Square.at(6, 3), Square.at(7, 3)])
  end

  def test_black_rook_blocked_by_black_piece_above
    blocked_test(Player::BLACK, Player::BLACK, 6, 3, [Square.at(6, 3), Square.at(7, 3)])
  end

  def test_white_rook_blocked_by_white_piece_to_left
    blocked_test(Player::WHITE, Player::WHITE, 3, 1, [Square.at(3, 1), Square.at(3, 0)])
  end

  def test_black_rook_blocked_by_black_piece_to_left
    blocked_test(Player::BLACK, Player::BLACK, 3, 1, [Square.at(3, 1), Square.at(3, 0)])
  end

  def test_white_rook_blocked_by_white_piece_to_right
    blocked_test(Player::WHITE, Player::WHITE, 3, 6, [Square.at(3, 6), Square.at(3, 7)])
  end

  def test_black_rook_blocked_by_black_piece_to_right
    blocked_test(Player::BLACK, Player::BLACK, 3, 6, [Square.at(3, 6), Square.at(3, 7)])
  end

  def test_white_rook_blocked_by_black_piece_below
    blocked_test(Player::WHITE, Player::BLACK, 1, 3, [Square.at(0, 3)])
  end

  def test_black_rook_blocked_by_white_piece_below
    blocked_test(Player::BLACK, Player::WHITE, 1, 3, [Square.at(0, 3)])
  end

  def test_white_rook_blocked_by_black_piece_above
    blocked_test(Player::WHITE, Player::BLACK, 6, 3, [Square.at(7, 3)])
  end

  def test_black_rook_blocked_by_white_piece_above
    blocked_test(Player::BLACK, Player::WHITE, 6, 3, [Square.at(7, 3)])
  end

  def test_white_rook_blocked_by_black_piece_to_left
    blocked_test(Player::WHITE, Player::BLACK, 3, 1, [Square.at(3, 0)])
  end

  def test_black_rook_blocked_by_white_piece_to_left
    blocked_test(Player::BLACK, Player::WHITE, 3, 1, [Square.at(3, 0)])
  end

  def test_white_rook_blocked_by_black_piece_to_right
    blocked_test(Player::WHITE, Player::BLACK, 3, 6, [Square.at(3, 7)])
  end

  def test_black_rook_blocked_by_white_piece_to_right
    blocked_test(Player::BLACK, Player::WHITE, 3, 6, [Square.at(3, 7)])
  end

  private def blocked_test(rook_player, pawn_player, pawn_row, pawn_column, blocked_squares)
    # Arrange
    rook, board = set_up_blocked_test(rook_player, pawn_player, pawn_row, pawn_column)

    # Act
    moves = rook.available_moves(board)

    # Assert
    assert_blocked_test(moves, rook_player, pawn_player, blocked_squares)
  end

  private def set_up_blocked_test(rook_player, pawn_player, pawn_row, pawn_column)
    board = Board.empty
    rook = Rook.new(rook_player)
    rook_square = Square.at(3, 3)
    board.set_piece(rook_square, rook)

    pawn = Pawn.new(pawn_player)
    pawn_square = Square.at(pawn_row, pawn_column)
    board.set_piece(pawn_square, pawn)

    [rook, board]
  end

  private def assert_blocked_test(moves, rook_player, pawn_player, blocked_squares)
    # Check blocked squares are NOT included
    blocked_squares.each { |square| refute_includes(moves, square) }
    # Check all horizontal and vertical moves EXCEPT to own square and blocked are included
    (0...Board.get_board_size).each do |i|
      assert_includes(moves, Square.at(i, 3)) if i != 3 && !blocked_squares.include?(Square.at(i, 3))
      assert_includes(moves, Square.at(3, i)) if i != 3 && !blocked_squares.include?(Square.at(3, i))
    end
    # Assert no other moves included
    assert_equal(moves.length, (rook_player == pawn_player ? 12 : 13))
  end
end
