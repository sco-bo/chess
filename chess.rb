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

  def valid_move?(current_square, desired_square, piece)
    if piece.class == Pawn && (desired_square.x == current_square.x)
      piece.get_valid_moves(current_square, desired_square)
    elsif piece.class == Pawn && (desired_square.x != current_square.x) && (desired_square.piece_on_square.color != piece.color)
      piece.get_valid_captures(current_square, desired_square)
    elsif piece.class == Pawn && (desired_square.x != current_square.x) && (desired_square.piece_on_square.color == piece.color)
      false
    else
     piece.class.get_valid_moves(current_square, desired_square)
    end
  end
end

class Board
  attr_accessor :square_hash
  Letters = ("a".."h").to_a
  Numbers = (1..8).to_a
  def initialize
    @history = History.new
    @square_hash = Hash.new
    assign_coordinate_names
  end

  def assign_coordinate_names
    Letters.each_with_index do |letter,index|
      Numbers.each do |n|
        @square_hash["#{letter}#{n}"] = Square.new(index+1,n,"#{letter}#{n}")
      end
    end
  end

  def square_free?(square)
    @square_hash[square].piece_on_square.nil?
  end

  def same_color_on_square?(square, player_color)
    @square_hash[square].piece_on_square.color == player_color
  end

  def path_clear?(current_square, desired_square, player_color)
    letters_hash = {1=>"a", 2=>"b", 3=>"c", 4=>"d", 5=>"e", 6=>"f", 7=>"g", 8=>"h"}
    path_clear = false
    if current_square.piece_type == Knight && (square_free?(desired_square.coordinates) || !same_color_on_square?(desired_square.coordinates, player_color))
      path_clear = true
    elsif current_square.piece_type == Knight && same_color_on_square?(desired_square.coordinates)
      puts "Piece(s) in way"
      path_clear = false
    elsif (current_square.x < desired_square.x) && (current_square.y < desired_square.y)
       (desired_square.x - current_square.x).times do |i| 
        i += 1
        if square_free?("#{letters_hash[current_square.x + i]}#{current_square.y + i}")
          path_clear = true
        elsif (current_square.x + i  == desired_square.x) && (current_square.y + i  == desired_square.y) && !same_color_on_square?(desired_square.coordinates, player_color)
          path_clear = true #can replace this with a "capture piece" action
        else 
          puts "Piece(s) in way"
          path_clear = false
          break
        end
        path_clear
      end
    elsif (current_square.x < desired_square.x) && (current_square.y > desired_square.y)
      (current_square.x - desired_square.x).times do |i| 
        i += 1
        if square_free?("#{letters_hash[current_square.x + i]}#{current_square.y + i}")
          path_clear = true
        elsif (current_square.x + i  == desired_square.x) && (current_square.y + i  == desired_square.y) && !same_color_on_square?(desired_square.coordinates, player_color)
          path_clear = true
        else 
          puts "Piece(s) in way"
          path_clear = false
          break
        end
        path_clear
      end
    elsif (current_square.x > desired_square.x) && (current_square.y > desired_square.y)
      (current_square.x - desired_square.x).times do |i|
        i += 1
        if square_free?("#{letters_hash[current_square.x - i]}#{current_square.y - i}")
          path_clear = true
        elsif (current_square.x - i == desired_square.x) && (current_square.y - i == desired_square.y) && !same_color_on_square?(desired_square.coordinates, player_color)
          path_clear = true
        else
          puts "Piece(s) in way"
          path_clear = false
          break
        end
        path_clear
      end
    elsif (current_square.x > desired_square.x) && (current_square.y < desired_square.y)
      (current_square.x - desired_square.x).times do |i|
        i += 1
        if square_free?("#{letters_hash[current_square.x - i]}#{current_square.y + i}")
          path_clear = true
        elsif (current_square.x - i == desired_square.x) && (current_square.y + i == desired_square.y) && !same_color_on_square?(desired_square.coordinates, player_color)
          path_clear = true
        else  
          puts "Piece(s) in way"
          path_clear = false
          break
        end
        path_clear
      end
    elsif current_square.x > desired_square.x
      (current_square.x - desired_square.x).times do |i| 
        i += 1
        if square_free?("#{letters_hash[current_square.x - i]}#{current_square.y}")
          path_clear = true
        elsif current_square.x - i == desired_square.x && !same_color_on_square?(desired_square.coordinates, player_color)
          path_clear = true
        else 
          puts "Piece(s) in way"
          path_clear = false
          break
        end
        path_clear
      end
    elsif current_square.x < desired_square.x
      (desired_square.x - current_square.x).times do |i|
        i += 1
        if square_free?("#{letters_hash[current_square.x + i]}#{current_square.y}")
          path_clear = true
        elsif current_square.x + i == desired_square.x && !same_color_on_square?(desired_square.coordinates, player_color)
          path_clear = true
        else 
          puts "Piece(s) in way"
          path_clear = false
          break
        end
        path_clear
      end
    elsif current_square.y > desired_square.y 
      (current_square.y - desired_square.y).times do |i|
        i += 1
        if square_free?("#{letters_hash[current_square.x]}#{current_square.y - i}")
          path_clear = true
        elsif current_square.y - i == desired_square.y && !same_color_on_square?(desired_square.coordinates, player_color)
          path_clear = true
        else 
          puts "Piece(s) in way"
          path_clear = false
          break
        end
        path_clear
      end
    elsif current_square.y < desired_square.y
       (desired_square.y - current_square.y).times do |i|
        i += 1
        if square_free?("#{letters_hash[current_square.x]}#{current_square.y + i}")
          path_clear = true
        elsif current_square.y + i == desired_square.y && !same_color_on_square?(desired_square.coordinates, player_color)
          path_clear = true
        else 
          puts "Piece(s) in way"
          path_clear = false
          break
        end
        path_clear
      end
    else 
      puts "Error"
      return false
    end
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
  def initialize(piece_on_square=nil, x, y, coordinates)
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
    @board.square_hash.each do |key,value|
      case value.y
      when 2
        value.piece_on_square = @player1.choose_player_piece(Pawn)
        @player1.choose_player_piece(Pawn).position = value.coordinates
      when 7
        value.piece_on_square = @player2.choose_player_piece(Pawn)
        @player2.choose_player_piece(Pawn).position = value.coordinates
      end

      case value.coordinates
      when "a1", "h1"
        value.piece_on_square = @player1.choose_player_piece(Rook)
        @player1.choose_player_piece(Rook).position = value.coordinates
      when "b1", "g1"
        value.piece_on_square = @player1.choose_player_piece(Knight)
        @player1.choose_player_piece(Knight).position = value.coordinates
      when "c1", "f1"
        value.piece_on_square = @player1.choose_player_piece(Bishop)
        @player1.choose_player_piece(Bishop).position = value.coordinates
      when "d1" 
        value.piece_on_square = @player1.choose_player_piece(Queen)
      when "e1"
        value.piece_on_square = @player1.choose_player_piece(King)
      when "a8", "h8"
        value.piece_on_square = @player2.choose_player_piece(Rook)
        @player2.choose_player_piece(Rook).position = value.coordinates
      when "b8", "g8"
        value.piece_on_square = @player2.choose_player_piece(Knight)
        @player2.choose_player_piece(Knight).position = value.coordinates
      when "c8", "f8"
        value.piece_on_square = @player2.choose_player_piece(Bishop)
        @player2.choose_player_piece(Bishop).position = value.coordinates
      when "d8"
        value.piece_on_square = @player2.choose_player_piece(Queen)
      when "e8"
        value.piece_on_square = @player2.choose_player_piece(King)
      end
    end
  end

  def play_game
    puts @board.square_hash
    move(current_player) #only structured for irb
    # while !@board.checkmate && !@board.stalemate?
    #   move(current_player)
    #   puts @board
    # end
    print_game_result
  end

  def move(player) 
    puts "Which piece would you like to move '#{player.color} player'? (please choose a square ex: c2)"
    choice = gets.chomp.downcase
    if @board.same_color_on_square?(choice, player.color)
      piece = @board.square_hash[choice].piece_on_square
      puts "To where would you like to move that #{piece.class}?"
      new_square = gets.chomp.downcase
      current_square = @board.square_hash[choice]
      desired_square = @board.square_hash[new_square]
      if current_player.valid_move?(current_square, desired_square, piece) && @board.path_clear?(current_square, desired_square, piece.color)
        puts "yep"
      else
        puts "Invalid move, please choose again"
      end
    else
      puts "You do not have a piece there, please choose again"
    end
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
  attr_accessor :turns_since_last_move, :on_initial_square, :color
  def initialize(color)
    super(color)
    @turns_since_last_move = 0
    @on_initial_square = true
  end

  def get_valid_moves(current_square, desired_square)
    potentials = []
    if @color == "white" && @on_initial_square
      potentials.push(
        [current_square.x, current_square.y + 1],
        [current_square.x, current_square.y + 2] 
        )
    elsif @on_initial_square && @color == "black"
      potentials = []
      potentials.push(
        [current_square.x, current_square.y - 1],
        [current_square.x, current_square.y - 2] 
        )
    elsif !@on_initial_square && @color == "white"
      potentials = []
      potentials.push(
        [current_square.x, current_square.y + 1]
        )
    elsif !@on_initial_square && @color == "black"
      potentials = []
      potentials.push(
        [current_square.x, current_square.y - 1]
        )
    end

    valid_children = potentials.select do |i|
      i[0].between?(0,8) &&
      i[1].between?(0,8)
    end
    valid_children.include? [desired_square.x, desired_square.y]   
  end

  def get_valid_captures(current_square, desired_square)
    potentials = []
    if @color == "white"
      potentials.push(
        [current_square.x + 1, current_square.y + 1],
        [current_square.x - 1, current_square.y + 1]
        )
    elsif @color == "black"
      potentials.push(
        [current_square.x - 1, current_square.y - 1],
        [current_square.x + 1, current_square.y - 1]
        )
    end

    valid_children = potentials.select do |i|
      i[0].between?(0,8) &&
      i[1].between?(0,8)
    end
    valid_children.include? [desired_square.x, desired_square.y]
  end
end

class Rook < Piece
  attr_accessor :has_moved
  def initialize(color)
    super(color)
    @has_moved = false
  end

  def self.get_valid_moves(current_square, desired_square)
    potentials = []
    potentials.push(
      [current_square.x + 1, current_square.y],
      [current_square.x + 2, current_square.y],
      [current_square.x + 3, current_square.y],
      [current_square.x + 4, current_square.y],
      [current_square.x + 5, current_square.y],
      [current_square.x + 6, current_square.y],
      [current_square.x + 7, current_square.y],
      [current_square.x, current_square.y + 1],
      [current_square.x, current_square.y + 2],
      [current_square.x, current_square.y + 3],
      [current_square.x, current_square.y + 4],
      [current_square.x, current_square.y + 5],
      [current_square.x, current_square.y + 6],
      [current_square.x, current_square.y + 7],
      [current_square.x - 1, current_square.y],
      [current_square.x - 2, current_square.y],
      [current_square.x - 3, current_square.y],
      [current_square.x - 4, current_square.y],
      [current_square.x - 5, current_square.y],
      [current_square.x - 6, current_square.y],
      [current_square.x - 7, current_square.y],
      [current_square.x, current_square.y - 1],
      [current_square.x, current_square.y - 2],
      [current_square.x, current_square.y - 3],
      [current_square.x, current_square.y - 4],
      [current_square.x, current_square.y - 5],
      [current_square.x, current_square.y - 6],
      [current_square.x, current_square.y - 7]
      )

    valid_children = potentials.select do |i|
      i[0].between?(0,8) &&
      i[1].between?(0,8)
    end
    valid_children.include? [desired_square.x, desired_square.y]
  end
end

class Knight < Piece
  def initialize(color)
    super(color)
  end

  def self.get_valid_moves(current_square, desired_square)
    potentials = []
    potentials.push(
      [current_square.x + 2, current_square.y + 1],
      [current_square.x + 2, current_square.y - 1],
      [current_square.x + 1, current_square.y + 2],
      [current_square.x + 1, current_square.y - 2],
      [current_square.x - 2, current_square.y + 1],
      [current_square.x - 2, current_square.y - 1], 
      [current_square.x - 1, current_square.y + 2], 
      [current_square.x - 1, current_square.y - 2]
      )

    valid_children = potentials.select do |i|
      i[0].between?(0,8) &&
      i[1].between?(0,8)
    end
    valid_children.include? [desired_square.x, desired_square.y]
  end
end

class Bishop < Piece
  def initialize(color)
    super(color)
  end

  def self.get_valid_moves(current_square, desired_square)
    potentials = []
    potentials.push(
      [current_square.x + 1, current_square.y + 1],
      [current_square.x + 2, current_square.y + 2],
      [current_square.x + 3, current_square.y + 3],
      [current_square.x + 4, current_square.y + 4],
      [current_square.x + 5, current_square.y + 5],
      [current_square.x + 6, current_square.y + 6],
      [current_square.x + 7, current_square.y + 7],
      [current_square.x - 1, current_square.y + 1],
      [current_square.x - 2, current_square.y + 2],
      [current_square.x - 3, current_square.y + 3],
      [current_square.x - 4, current_square.y + 4],
      [current_square.x - 5, current_square.y + 5],
      [current_square.x - 6, current_square.y + 6],
      [current_square.x - 7, current_square.y + 7],
      [current_square.x + 1, current_square.y - 1],
      [current_square.x + 2, current_square.y - 2],
      [current_square.x + 3, current_square.y - 3],
      [current_square.x + 4, current_square.y - 4],
      [current_square.x + 5, current_square.y - 5],
      [current_square.x + 6, current_square.y - 6],
      [current_square.x + 7, current_square.y - 7],
      [current_square.x - 1, current_square.y - 1],
      [current_square.x - 2, current_square.y - 2],
      [current_square.x - 3, current_square.y - 3],
      [current_square.x - 4, current_square.y - 4],
      [current_square.x - 5, current_square.y - 5],
      [current_square.x - 6, current_square.y - 6],
      [current_square.x - 7, current_square.y - 7]
      )

    valid_children = potentials.select do |i|
      i[0].between?(0,8) &&
      i[1].between?(0,8)
    end
    valid_children.include? [desired_square.x, desired_square.y]
  end
end

class Queen < Piece
  def initialize(color)
    super(color)
  end

  def self.get_valid_moves(current_square, desired_square)
    potentials = []
    potentials.push(
      [current_square.x + 1, current_square.y],
      [current_square.x + 2, current_square.y],
      [current_square.x + 3, current_square.y],
      [current_square.x + 4, current_square.y],
      [current_square.x + 5, current_square.y],
      [current_square.x + 6, current_square.y],
      [current_square.x + 7, current_square.y],
      [current_square.x, current_square.y + 1],
      [current_square.x, current_square.y + 2],
      [current_square.x, current_square.y + 3],
      [current_square.x, current_square.y + 4],
      [current_square.x, current_square.y + 5],
      [current_square.x, current_square.y + 6],
      [current_square.x, current_square.y + 7],
      [current_square.x - 1, current_square.y],
      [current_square.x - 2, current_square.y],
      [current_square.x - 3, current_square.y],
      [current_square.x - 4, current_square.y],
      [current_square.x - 5, current_square.y],
      [current_square.x - 6, current_square.y],
      [current_square.x - 7, current_square.y],
      [current_square.x, current_square.y - 1],
      [current_square.x, current_square.y - 2],
      [current_square.x, current_square.y - 3],
      [current_square.x, current_square.y - 4],
      [current_square.x, current_square.y - 5],
      [current_square.x, current_square.y - 6],
      [current_square.x, current_square.y - 7],
      [current_square.x + 1, current_square.y + 1],
      [current_square.x + 2, current_square.y + 2],
      [current_square.x + 3, current_square.y + 3],
      [current_square.x + 4, current_square.y + 4],
      [current_square.x + 5, current_square.y + 5],
      [current_square.x + 6, current_square.y + 6],
      [current_square.x + 7, current_square.y + 7],
      [current_square.x - 1, current_square.y + 1],
      [current_square.x - 2, current_square.y + 2],
      [current_square.x - 3, current_square.y + 3],
      [current_square.x - 4, current_square.y + 4],
      [current_square.x - 5, current_square.y + 5],
      [current_square.x - 6, current_square.y + 6],
      [current_square.x - 7, current_square.y + 7],
      [current_square.x + 1, current_square.y - 1],
      [current_square.x + 2, current_square.y - 2],
      [current_square.x + 3, current_square.y - 3],
      [current_square.x + 4, current_square.y - 4],
      [current_square.x + 5, current_square.y - 5],
      [current_square.x + 6, current_square.y - 6],
      [current_square.x + 7, current_square.y - 7],
      [current_square.x - 1, current_square.y - 1],
      [current_square.x - 2, current_square.y - 2],
      [current_square.x - 3, current_square.y - 3],
      [current_square.x - 4, current_square.y - 4],
      [current_square.x - 5, current_square.y - 5],
      [current_square.x - 6, current_square.y - 6],
      [current_square.x - 7, current_square.y - 7]
      )

    valid_children = potentials.select do |i|
      i[0].between?(0,8) &&
      i[1].between?(0,8)
    end
    valid_children.include? [desired_square.x, desired_square.y]
  end
end

class King < Piece
  attr_accessor :has_moved
  def initialize(color)
    super(color)
    @has_moved = false
  end

  def self.get_valid_moves(current_square, desired_square)
    potentials = []
    potentials.push(
      [current_square.x, current_square.y + 1],
      [current_square.x, current_square.y - 1],
      [current_square.x + 1, current_square.y],
      [current_square.x - 1, current_square.y],
      [current_square.x + 1, current_square.y + 1],
      [current_square.x - 1, current_square.y - 1],
      [current_square.x + 1, current_square.y - 1],
      [current_square.x - 1, current_square.y + 1]
      )

    valid_children = potentials.select do |i|
      i[0].between?(0,8) &&
      i[1].between?(0,8)
    end
    valid_children.include? [desired_square.x, desired_square.y]
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

