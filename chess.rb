class Player
  attr_accessor :color, :pawn, :rook, :knight, :bishop, :queen, :king
  def initialize(color)
    @pawn = Pawn.new(color)
    @rook = Rook.new(color)
    @knight = Knight.new(color)
    @bishop = Bishop.new(color)
    @queen = Queen.new(color)
    @king = King.new(color)
  end
end

class Board
  def initialize
    @a1 = Square.new  
  end

  def place_piece(piece)
    @a1.piece_on_square = piece
  end
end

class Game
  def initialize
    @board = Board.new
    @player1 = Player.new("white")
    @player2 = Player.new("black")
  end

  def move 
    @board.place_piece(@player1.rook)
  end
end

class Square
  attr_accessor :piece_on_square
  def initialize
    @piece_on_square = piece_on_square
  end
end

class Piece
  attr_accessor :color, :position
  def initialize(color)
    @color = color
    @position = position
  end
end

class Pawn < Piece
  attr_accessor :turns_since_last_move
  def initialize(color)
    super(color)
    @turns_since_last_move = 0
  end
end

class Rook < Piece
  attr_accessor :has_moved
  def initialize(color)
    super(color)
    @has_moved = false
  end
end

class Knight < Piece
  def initialize(color)
    super(color)
  end
end

class Bishop < Piece
  def initialize(color)
    super(color)
  end
end

class Queen < Piece
  def initialize(color)
    super(color)
  end
end

class King < Piece
  attr_accessor :has_moved
  def initialize(color)
    super(color)
    @has_moved = false
  end
end

