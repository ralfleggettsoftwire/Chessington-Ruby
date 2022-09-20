module Chessington
  module Engine
    ##
    # An abstract base class from which all pieces inherit.
    module Piece
      attr_reader :player, :moves_made
      attr_accessor :last_piece_to_move

      def initialize(player)
        @player = player
        @moves_made = 0
        @last_piece_to_move = false
      end

      ##
      #  Get all squares that the piece is allowed to move to.
      def available_moves(board)
        raise "Not implemented"
      end

      ##
      # Checks if piece would be obstructed while attempting to move to new_square
      def is_obstructed(board, square, new_square, *)
        raise "Not implemented"
      end

      ##
      # Move this piece to the given square on the board.
      def move_to(board, new_square)
        current_square = board.find_piece(self)
        board.move_piece(current_square, new_square)
        @moves_made += 1
      end

      ##
      # Check if there is a piece at square and if it belongs to the opponent
      def opponent_piece_at?(board, square)
        piece = board.get_piece(square)
        piece && piece.player == @player.opponent
      end
    end

    ##
    # A class for pieces that sweep across the board in straight and/or diagonal directions for a potentially limited
    # number of squares (e.g. King)
    module SweepingPiece
      include Piece

      Direction = Struct.new(:row_addition, :column_addition) do
        self::NORTH = new(1, 0)
        self::SOUTH = new(-1, 0)
        self::EAST = new(0, 1)
        self::WEST = new(0, -1)
        self::NORTHEAST = new(1, 1)
        self::NORTHWEST = new(1, -1)
        self::SOUTHEAST = new(-1, 1)
        self::SOUTHWEST = new(-1, -1)

        def get_next_square_in_direction(square)
          square.copy.add(row_addition, column_addition)
        end

        private_class_method :new
      end

      DIAGONAL = [Direction::NORTHEAST, Direction::NORTHWEST, Direction::SOUTHEAST, Direction::SOUTHWEST]
      STRAIGHT = [Direction::NORTH, Direction::SOUTH, Direction::EAST, Direction::WEST]
      STRAIGHT_AND_DIAGONAL = STRAIGHT + DIAGONAL

      def available_moves(board)
        available_moves = []
        current_square = board.find_piece(self)

        @directions.each do |dir|
          available_moves += get_moves_in_direction(board, dir, current_square)
        end
        available_moves
      end

      def get_moves_in_direction(board, direction, current_square)
        moves = []
        new_square = current_square.copy
        (1..@range).each do
          new_square = direction.get_next_square_in_direction(new_square)
          if is_unobstructed_valid_square?(board, current_square, new_square, direction)
            moves << new_square
          else
            break
          end
        end
        moves
      end

      def is_unobstructed_valid_square?(board, current_square, new_square, direction)
        is_valid_square = Board.is_valid_square?(new_square)
        if is_valid_square && is_obstructed?(board, current_square, new_square, direction)
          opponent_piece_at?(board, new_square)
        else
          is_valid_square
        end
      end

      def is_obstructed?(board, square, new_square, direction)
        test_square = square.copy
        squares_to_test = []
        until test_square == new_square
          test_square = direction.get_next_square_in_direction(test_square)
          squares_to_test << test_square
        end
        squares_to_test.any? { |sq| board.get_piece(sq) }
      end
    end

    ##
    # A class representing a chess pawn.
    class Pawn
      include Piece

      def is_obstructed?(board, square, new_square)
        start_row = square.row + (@player == Player::WHITE ? 1 : -1)
        end_row = new_square.row
        ([start_row, end_row].min..[start_row, end_row].max).any? do |row|
          board.get_piece(Square.at(row, square.column))
        end
      end

      def add_forward_move_if_valid(current_square, available_moves)
        new_square = current_square.copy.add(@player == Player::WHITE ? 1 : -1, 0)
        available_moves << new_square unless
          !Board.is_valid_square?(new_square) || is_obstructed?(board, current_square, new_square)
      end

      def add_double_forward_move_if_valid(current_square, available_moves)
        new_square = current_square.copy.add(@player == Player::WHITE ? 2 : -2, 0)
        available_moves << new_square unless
          !Board.is_valid_square?(new_square) || @moves_made > 0 || is_obstructed?(board, current_square, new_square)
      end

      def add_diagonal_moves_if_valid(current_square, available_moves)
        left_square = current_square.copy.add(@player == Player::WHITE ? 1 : -1, @player == Player::WHITE ? -1 : 1)
        available_moves << left_square if Board.is_valid_square?(left_square) && opponent_piece_at?(board, left_square)

        right_square = current_square.copy.add(@player == Player::WHITE ? 1 : -1, @player == Player::WHITE ? 1 : -1)
        available_moves << right_square if Board.is_valid_square?(right_square) && opponent_piece_at?(board, right_square)
      end

      def add_en_passant_moves_if_valid(current_square, available_moves)
        # Check for en passant on left (and allow move to new_square if so)
        left_square = current_square.copy.add(@player == Player::WHITE ? 1 : -1, @player == Player::WHITE ? -1 : 1)
        en_passant_left_square = current_square.copy.add(0, @player == Player::WHITE ? -1 : 1)
        available_moves << left_square if
          Board.is_valid_square?(left_square) && opponent_piece_at?(board, en_passant_left_square) &&
            board.get_piece(en_passant_left_square).moves_made == 1 &&
            board.get_piece(en_passant_left_square).instance_of?(Pawn) &&
            board.get_piece(en_passant_left_square).last_piece_to_move && !available_moves.include?(left_square)

        # Check for en passant on right (and allow move to new_square if so)
        right_square = current_square.copy.add(@player == Player::WHITE ? 1 : -1, @player == Player::WHITE ? 1 : -1)
        en_passant_right_square = current_square.copy.add(0, @player == Player::WHITE ? 1 : -1)
        available_moves << right_square if
          Board.is_valid_square?(right_square) && opponent_piece_at?(board, en_passant_right_square) &&
            board.get_piece(en_passant_right_square).moves_made == 1 &&
            board.get_piece(en_passant_right_square).instance_of?(Pawn) &&
            board.get_piece(en_passant_right_square).last_piece_to_move && !available_moves.include?(right_square)
      end

      def available_moves(board)
        available_moves = []
        current_square = board.find_piece(self)

        add_forward_move_if_valid(current_square, available_moves)
        add_double_forward_move_if_valid(current_square, available_moves)
        add_diagonal_moves_if_valid(current_square, available_moves)
        add_en_passant_moves_if_valid(current_square, available_moves)
        available_moves
      end
    end

    ##
    # A class representing a chess knight.
    class Knight
      include Piece

      def is_obstructed?(board, square, new_square, *)
        !opponent_piece_at?(board, new_square) && board.get_piece(new_square)
      end

      def available_moves(board)
        available_moves = []
        current_square = board.find_piece(self)

        [[2, -1], [2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2]].each do |row_add, col_add|
          new_square = current_square.copy.add(row_add, col_add)
          available_moves << new_square if
            Board.is_valid_square?(new_square) && !is_obstructed?(board, current_square, new_square)
        end
        available_moves
      end
    end

    ##
    # A class representing a chess bishop.
    class Bishop
      include SweepingPiece

      def initialize(player)
        super
        @directions = SweepingPiece::DIAGONAL
        @range = Board.get_board_size
      end
    end

    ##
    # A class representing a chess rook.
    class Rook
      include SweepingPiece

      def initialize(player)
        super
        @directions = SweepingPiece::STRAIGHT
        @range = Board.get_board_size
      end
    end

    ##
    # A class representing a chess queen.
    class Queen
      include SweepingPiece

      def initialize(player)
        super
        @directions = SweepingPiece::STRAIGHT_AND_DIAGONAL
        @range = Board.get_board_size
      end
    end

    ##
    # A class representing a chess king.
    class King
      include SweepingPiece

      def initialize(player)
        super
        @directions = SweepingPiece::STRAIGHT_AND_DIAGONAL
        @range = 1
      end

      def available_moves(board)
        available_moves = super
        current_square = board.find_piece(self)

        # Castling
        if @moves_made == 0
          queen_side_piece = board.get_piece(Square.at(@player == Player::WHITE ? 0 : 7, 0))
          queen_side_piece_is_valid = queen_side_piece && queen_side_piece.moves_made == 0 && queen_side_piece.instance_of?(Rook)
          queen_side_square = Square.at(@player == Player::WHITE ? 0 : 7, 2)
          available_moves << queen_side_square if
            queen_side_piece_is_valid && !is_obstructed?(board, current_square, queen_side_square, Direction::WEST)

          king_side_piece = board.get_piece(Square.at(@player == Player::WHITE ? 0 : 7, 7))
          king_side_piece_is_valid = king_side_piece && king_side_piece.moves_made == 0 && king_side_piece.instance_of?(Rook)
          king_side_square = Square.at(@player == Player::WHITE ? 0 : 7, 6)
          available_moves << king_side_square if
            king_side_piece_is_valid && !is_obstructed?(board, current_square, king_side_square, Direction::EAST)
        end
        available_moves
      end
    end
  end
end
