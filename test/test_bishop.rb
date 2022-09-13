require_relative 'test_helper'
require 'Chessington/engine'

class TestBishop < Minitest::Test
  include Chessington::Engine

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
    (1...[Board.get_board_size - 3, 3].max).each do |i|
      assert_includes(moves, Square.at(3 - i, 3 - i)) if board.is_valid_square?(Square.at(3 - i, 3 - i))
      assert_includes(moves, Square.at(3 - i, 3 + i)) if board.is_valid_square?(Square.at(3 - i, 3 + i))
      assert_includes(moves, Square.at(3 + i, 3 - i)) if board.is_valid_square?(Square.at(3 + i, 3 - i))
      assert_includes(moves, Square.at(3 + i, 3 + i)) if board.is_valid_square?(Square.at(3 + i, 3 + i))
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
    (1...[Board.get_board_size - 3, 3].max).each do |i|
      assert_includes(moves, Square.at(3 - i, 3 - i)) if board.is_valid_square?(Square.at(3 - i, 3 - i))
      assert_includes(moves, Square.at(3 - i, 3 + i)) if board.is_valid_square?(Square.at(3 - i, 3 + i))
      assert_includes(moves, Square.at(3 + i, 3 - i)) if board.is_valid_square?(Square.at(3 + i, 3 - i))
      assert_includes(moves, Square.at(3 + i, 3 + i)) if board.is_valid_square?(Square.at(3 + i, 3 + i))
    end
    # Assert no other moves included
    assert_equal(13, moves.length)
  end

  def test_white_bishop_blocked_by_white_piece_to_northeast
    blocked_test(Player::WHITE, Player::WHITE, Square.at(6, 6), [Square.at(6, 6), Square.at(7, 7)])
  end

  def test_white_bishop_blocked_by_white_piece_to_southeast
    blocked_test(Player::WHITE, Player::WHITE, Square.at(1, 5), [Square.at(1, 5), Square.at(0, 6)])
  end

  def test_white_bishop_blocked_by_white_piece_to_southwest
    blocked_test(Player::WHITE, Player::WHITE, Square.at(1, 1), [Square.at(1, 1), Square.at(0, 0)])
  end

  def test_white_bishop_blocked_by_white_piece_to_northwest
    blocked_test(Player::WHITE, Player::WHITE, Square.at(5, 1), [Square.at(5, 1), Square.at(6, 0)])
  end

  def test_black_bishop_blocked_by_black_piece_to_northeast
    blocked_test(Player::BLACK, Player::BLACK, Square.at(6, 6), [Square.at(6, 6), Square.at(7, 7)])
  end

  def test_black_bishop_blocked_by_black_piece_to_southeast
    blocked_test(Player::BLACK, Player::BLACK, Square.at(1, 5), [Square.at(1, 5), Square.at(0, 6)])
  end

  def test_black_bishop_blocked_by_black_piece_to_southwest
    blocked_test(Player::BLACK, Player::BLACK, Square.at(1, 1), [Square.at(1, 1), Square.at(0, 0)])
  end

  def test_black_bishop_blocked_by_black_piece_to_northwest
    blocked_test(Player::BLACK, Player::BLACK, Square.at(5, 1), [Square.at(5, 1), Square.at(6, 0)])
  end

  def test_white_bishop_blocked_by_black_piece_to_northeast
    blocked_test(Player::WHITE, Player::BLACK, Square.at(6, 6), [Square.at(7, 7)])
  end

  def test_white_bishop_blocked_by_black_piece_to_southeast
    blocked_test(Player::WHITE, Player::BLACK, Square.at(1, 5), [Square.at(0, 6)])
  end

  def test_white_bishop_blocked_by_black_piece_to_southwest
    blocked_test(Player::WHITE, Player::BLACK, Square.at(1, 1), [Square.at(0, 0)])
  end

  def test_white_bishop_blocked_by_black_piece_to_northwest
    blocked_test(Player::WHITE, Player::BLACK, Square.at(5, 1), [Square.at(6, 0)])
  end

  def test_black_bishop_blocked_by_white_piece_to_northeast
    blocked_test(Player::BLACK, Player::WHITE, Square.at(6, 6), [Square.at(7, 7)])
  end

  def test_black_bishop_blocked_by_white_piece_to_southeast
    blocked_test(Player::BLACK, Player::WHITE, Square.at(1, 5), [Square.at(0, 6)])
  end

  def test_black_bishop_blocked_by_white_piece_to_southwest
    blocked_test(Player::BLACK, Player::WHITE, Square.at(1, 1), [Square.at(0, 0)])
  end

  def test_black_bishop_blocked_by_white_piece_to_northwest
    blocked_test(Player::BLACK, Player::WHITE, Square.at(5, 1), [Square.at(6, 0)])
  end

  private def blocked_test(bishop_player, pawn_player, pawn_square, blocked_squares)
    # Arrange
    bishop, board = set_up_blocked_test(bishop_player, pawn_player, pawn_square)

    # Act
    moves = bishop.available_moves(board)

    # Assert
    assert_blocked_test(board, moves, bishop_player, pawn_player, blocked_squares)
  end

  private def set_up_blocked_test(bishop_player, pawn_player, pawn_square)
    board = Board.empty
    bishop = Bishop.new(bishop_player)
    bishop_square = Square.at(3, 3)
    board.set_piece(bishop_square, bishop)

    pawn = Pawn.new(pawn_player)
    board.set_piece(pawn_square, pawn)

    [bishop, board]
  end

  private def assert_blocked_test(board, moves, bishop_player, pawn_player, blocked_squares)
    # Check blocked squares are NOT included
    blocked_squares.each { |square| refute_includes(moves, square) }
    # Check all diagonal moves EXCEPT to blocked squares are included
    (1...Board.get_board_size).each do |i|
      [
        Square.at(3 - i, 3 - i),
        Square.at(3 - i, 3 + i),
        Square.at(3 + i, 3 - i),
        Square.at(3 + i, 3 + i)
      ].each do |square|
        assert_includes(moves, square) if board.is_valid_square?(square) && !blocked_squares.include?(square)
      end
    end
    # Assert no other moves included
    assert_equal((bishop_player == pawn_player ? 11 : 12), moves.length)
  end
end
