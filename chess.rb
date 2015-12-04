class Player
  attr_accessor :color, :pieces
  def initialize(color)
    @color = color
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

  def valid_move?(current_square, new_square, type_of_piece)
    type_of_piece.get_valid_moves.include?(new_square)
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

  def piece_type
    self.piece_on_square.class
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
    @board.square_array.each do |i|
      case i.y
      when 2
        i.piece_on_square = @player1.choose_player_piece(Pawn)
        @player1.choose_player_piece(Pawn).position = i.coordinates
      when 7
        i.piece_on_square = @player2.choose_player_piece(Pawn)
        @player2.choose_player_piece(Pawn).position = i.coordinates
      end

      case i.coordinates
      when "a1" || "h1"
        i.piece_on_square = @player1.choose_player_piece(Rook)
        @player1.choose_player_piece(Rook).position = i.coordinates
      when "b1" || "g1"
        i.piece_on_square = @player1.choose_player_piece(Knight)
        @player1.choose_player_piece(Knight).position = i.coordinates
      when "c1" || "f1"
        i.piece_on_square = @player1.choose_player_piece(Bishop)
        @player1.choose_player_piece(Bishop).position = i.coordinates
      when "d1" 
        i.piece_on_square = @player1.choose_player_piece(Queen)
      when "e1"
        i.piece_on_square = @player1.choose_player_piece(King)
      when "a8" || "h8"
        i.piece_on_square = @player2.choose_player_piece(Rook)
        @player2.choose_player_piece(Rook).position = i.coordinates
      when "b8" || "g8"
        i.piece_on_square = @player2.choose_player_piece(Knight)
        @player2.choose_player_piece(Knight).position = i.coordinates
      when "c8" || "f8"
        i.piece_on_square = @player2.choose_player_piece(Bishop)
        @player2.choose_player_piece(Bishop).position = i.coordinates
      when "d8"
        i.piece_on_square = @player2.choose_player_piece(Queen)
      when "e8"
        i.piece_on_square = @player2.choose_player_piece(King)
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

  def get_piece_type(square)
    @board.find_square(square).piece_type
  end

  def move(player) 
    puts "Which piece would you like to move '#{player.color} player'? (please choose a square ex: c2)"
    choice = gets.chomp.downcase
    if @board.piece_present?(choice, player.color)
      type_of_piece = get_piece_type(choice)
      puts "To where would you like to move that piece?"
      new_square = gets.chomp.downcase
      if player.valid_move?(choice, new_square, type_of_piece)
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

  def self.get_valid_moves
    puts "does this stuff"
  end
end

class Rook < Piece
  attr_accessor :has_moved
  def initialize(color)
    super(color)
    @has_moved = false
  end

  def self.get_valid_moves
    puts "does this stuff"
  end
end

class Knight < Piece
  def initialize(color)
    super(color)
  end

  def self.get_valid_moves
    puts "does this stuff"
  end
end

class Bishop < Piece
  def initialize(color)
    super(color)
  end

  def self.get_valid_moves
    puts "does this stuff"
  end
end

class Queen < Piece
  def initialize(color)
    super(color)
  end

  def self.get_valid_moves
    puts "does this stuff"
  end
end

class King < Piece
  attr_accessor :has_moved
  def initialize(color)
    super(color)
    @has_moved = false
  end

  def self.get_valid_moves
    puts "does this stuff"
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

