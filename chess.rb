class Player
  attr_accessor :color, :pawn1, :pawn2, :pawn3, :pawn4, :pawn5, :pawn6, :pawn7, :pawn8, :rook1, :rook2, :knight1, :knight2, :bishop1, :bishop2, :queen, :king
  def initialize(color)
    @pawn1 = Pawn.new(color)
    @pawn2 = Pawn.new(color)
    @pawn3 = Pawn.new(color)
    @pawn4 = Pawn.new(color)
    @pawn5 = Pawn.new(color)
    @pawn6 = Pawn.new(color)
    @pawn7 = Pawn.new(color)
    @pawn8 = Pawn.new(color)
    @rook1 = Rook.new(color)
    @rook2 = Rook.new(color)
    @knight1 = Knight.new(color)
    @knight2 = Knight.new(color)
    @bishop1 = Bishop.new(color)
    @bishop2 = Bishop.new(color)
    @queen = Queen.new(color)
    @king = King.new(color)
  end
end

class Board
  Letters = ('a'..'z').to_a
  Numbers = (1..8).to_a
  def initialize
    @history = History.new
    @square_array = Array.new(64){Square.new}
    assign_coordinates
  end

  def assign_coordinates
    Letters.product(Numbers).zip(@square_array){|*a, e| e.coordinates = a.join}
  end

  def find_square
    @square_array.select do |i|
      i.coordinates == square
    end
  end

  def piece_present?(square, player_color)
    return square.piece_on_square.color == player_color
  end

  def place_piece(piece)
    @a1.piece_on_square = piece
    p @a1
  end

  def to_s

  end

  def store_snapshot

  end
end

class History
  attr_accessor :snapshot
  def initialize
    @snapshot = Array.new
  end
end

class Game
  def initialize
    @board = Board.new
    @player1 = Player.new("white")
    @player2 = Player.new("black")
    @current_turn = 1
  end

  def play_game
    puts @board
    while !@board.checkmate && !@board.stalemate?
      move(current_player)
      puts @board
    end
    print_game_result
  end

  def move(player) 
    puts "Which piece would you like to move 'player #{player.color}'? (please choose a square ex: c2)"
    choice = gets.chomp.downcase
    @board.piece_present?(choice, player.color)
    @board.place_piece(@player1.rook)
  end

  def current_player
    @current_turn.even? ? @player2 : @player1
  end
end

class Piece
  attr_accessor :color, :position
  def initialize(color)
    @color = color
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


def play_again?
  puts "Play again? (yes or no)"
  answer = gets.chomp.downcase
  return answer == "yes"
end

loop do 
  Game.new.play_game
  unless play_again?
    puts "Goodbye"
    break
  end
end
end

