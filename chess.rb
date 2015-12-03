class Player
  attr_accessor :color, :pawn1, :pawn2, :pawn3, :pawn4, :pawn5, :pawn6, :pawn7, :pawn8, :rook1, :rook2, :knight1, :knight2, :bishop1, :bishop2, :queen, :king
  def initialize(color)
    @color = color
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

  def valid_move?(current_square, new_square)

  end

  def get_moves(piece)

  end
end

class Board
  attr_accessor :square_array
  Letters = ("a".."h").to_a
  Numbers = (1..8).to_a
  def initialize
    @history = History.new
    @square_array = Array.new(64){Square.new}
    assign_coordinate_names
    assign_xy_values
  end

  def assign_coordinate_names
    Letters.product(Numbers).zip(@square_array){|a, e| e.coordinates = a.join}
  end

  def assign_xy_values
    @square_array.each_with_index do |i, index|
      i.y = index % 8 + 1
      i.x = (index/8) + 1
    end
  end

  def find_square(location)
    @square_array.find {|i| i.coordinates == location}
  end

  def piece_present?(square, player_color)
    return find_square(square).piece_on_square.color == player_color
  end

  def place_piece(piece)
    
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

class Square
  attr_accessor :piece_on_square, :x, :y, :coordinates
  def initialize(piece_on_square=nil, x=nil, y=nil, coordinates=nil)
    @piece_on_square = piece_on_square
    @x = x
    @y = y
    @coordinates = coordinates
  end
end

class Game
  attr_accessor :board #only doing this for irb tests
  def initialize
    @player1 = Player.new("white")
    @player2 = Player.new("black")
    @board = Board.new
    set_opening_positions
    @current_turn = 1
  end

  def set_opening_positions
    @board.square_array.each_with_index do |i, index|
      case i.coordinates
      when "a1"
        i.piece_on_square = @player1.rook1
      when "b1"
        i.piece_on_square = @player1.knight1
      when "c1"
        i.piece_on_square = @player1.bishop1
      when "d1"
        i.piece_on_square = @player1.king
      when "e1"
        i.piece_on_square = @player1.queen
      when "f1"
        i.piece_on_square = @player1.bishop2
      when "g1"
        i.piece_on_square = @player1.knight2
      when "h1"
        i.piece_on_square = @player1.rook2
      when "a2"
        i.piece_on_square = @player1.pawn1
      when "b2"
        i.piece_on_square = @player1.pawn2
      when "c2"
        i.piece_on_square = @player1.pawn3
      when "d2"
        i.piece_on_square = @player1.pawn4
      when "e2"
        i.piece_on_square = @player1.pawn5
      when "f2"
        i.piece_on_square = @player1.pawn6
      when "g2"
        i.piece_on_square = @player1.pawn7
      when "h2"
        i.piece_on_square = @player1.pawn8
      when "a8"
        i.piece_on_square = @player2.rook1
      when "b8"
        i.piece_on_square = @player2.knight1
      when "c8"
        i.piece_on_square = @player2.bishop1
      when "d8"
        i.piece_on_square = @player2.queen
      when "e8"
        i.piece_on_square = @player2.king
      when "f8"
        i.piece_on_square = @player2.bishop2
      when "g8"
        i.piece_on_square = @player2.knight2
      when "h8"
        i.piece_on_square = @player2.rook2
      when "a7"
        i.piece_on_square = @player2.pawn1
      when "b7"
        i.piece_on_square = @player2.pawn2
      when "c7"
        i.piece_on_square = @player2.pawn3
      when "d7"
        i.piece_on_square = @player2.pawn4
      when "e7"
        i.piece_on_square = @player2.pawn5
      when "f7"
        i.piece_on_square = @player2.pawn6
      when "g7"
        i.piece_on_square = @player2.pawn7
      when "h7"
        i.piece_on_square = @player2.pawn8
      else
        i.piece_on_square = nil
      end
    end
  end

  def play_game
    puts @board
    move(current_player) #only structured for irb
    while !@board.checkmate && !@board.stalemate?
      move(current_player)
      puts @board
    end
    print_game_result
  end

  def move(player) 
    puts "Which piece would you like to move '#{player.color} player'? (please choose a square ex: c2)"
    choice = gets.chomp.downcase
    if @board.piece_present?(choice, player.color)
      puts "To where would you like to move that piece?"
      new_square = gets.chomp.downcase
      if player.valid_move?(choice, new_square)
        @board.place_piece(new_square)
        @current_turn += 1
      else
        puts "Invalid move, please choose again"
      end
    else
      puts "You do not have a piece there, please choose again"
    end
      @board.place_piece(@player1.rook)
  end

  def current_player
    @current_turn.even? ? @player2 : @player1
  end
end

class Piece
  attr_accessor :color, :position
  def initialize(color, position=nil)
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


# def play_again?
#   puts "Play again? (yes or no)"
#   answer = gets.chomp.downcase
#   return answer == "yes"
# end

# loop do 
#   Game.new.play_game
#   unless play_again?
#     puts "Goodbye"
#     break
#   end
# end

