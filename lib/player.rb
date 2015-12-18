class Player
  attr_accessor :color, :pieces, :captured_pieces
  def initialize(color)
    @color = color
    @captured_pieces = []
    @pieces = [Pawn.new(color),
               Pawn.new(color),
               Pawn.new(color),
               Pawn.new(color),
               Pawn.new(color),
               Pawn.new(color),
               Pawn.new(color),
               Pawn.new(color),
               Rook.new(color),
               Rook.new(color),
               Knight.new(color),
               Knight.new(color),
               Bishop.new(color),
               Bishop.new(color),
               Queen.new(color),
               King.new(color)
              ]
  end

  def choose_player_piece(type)
    @pieces.find {|i| i.class == type && i.position == nil}
  end

  def valid_move?(current_square, desired_square, piece)
    if piece.class == Pawn && (desired_square.x == current_square.x)
      piece.get_valid_moves(current_square, desired_square)
    elsif piece.class == Pawn && (desired_square.x != current_square.x) && (desired_square.piece_on_square.color != piece.color)
      piece.get_valid_captures(current_square, desired_square)
    elsif piece.class == Pawn && (desired_square.x != current_square.x) && (desired_square.piece_on_square.nil? || desired_square.piece_on_square.color == piece.color)
      false
    else
     piece.class.get_valid_moves(current_square, desired_square)
    end
  end

  def in_check?(current_square, desired_square)
    if current_square.nil?

    end
  end

  def en_passant_move?(current_square, desired_square, piece)
    piece.get_en_passant_moves(current_square, desired_square)
  end

  def set_position(piece, desired_square)
    piece.position = desired_square.coordinates
  end

  def short_side_rook
    if self.color == "white"
      @pieces.find {|i| i.position == "h1"}
    elsif self.color == "black"
      @pieces.find {|i| i.position == "h8"}
    end
  end

  def long_side_rook
    if self.color == "white"
      @pieces.find {|i| i.position == "a1"}
    elsif self.color == "black"
      @pieces.find {|i| i.position == "a8"}
    end      
  end

  def king
    @pieces.find {|i| i.class == King}
  end

  def pieces_on_initial_square?
    if self.long_side_rook.on_initial_square && self.king.on_initial_square
      true
    else  
      false
    end
  end
end