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

class Board
  attr_accessor :square_hash, :history, :last_move
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

  def store_board
    @history.snapshot.push(@simplified_board)
  end

  def store_move(starting_square, final_square)
    @history.last_move = {}
    @history.last_move["#{starting_square.piece_on_square.class}"] = [starting_square, final_square]
  end

  def create_simplified_board
    @simplified_board = {}
    @square_hash.each do |k,v|
      if v.piece_on_square.nil?
        simplified_board[k] = v.piece_on_square
      else
        simplified_board[k] = v.piece_on_square.class.to_s
      end
    end
    @simplified_board
  end

  def place_piece(initial_square, final_square)
    final_square.piece_on_square = initial_square.piece_on_square
    initial_square.piece_on_square = nil
  end

  def square_free?(square)
    @square_hash[square].piece_on_square.nil?
  end

  def same_color_on_square?(square, player_color)
    if !square_free?(square) && @square_hash[square].piece_on_square.color == player_color
      true
    else
      false
    end
  end

  def diagonal_up_right?(current_square, desired_square)
    if (current_square.x < desired_square.x) && (current_square.y < desired_square.y)
      true
    else
      false
    end
  end

  def diagonal_down_right?(current_square, desired_square)
    if (current_square.x < desired_square.x) && (current_square.y > desired_square.y)
      true
    else
      false
    end
  end

  def diagonal_up_left?(current_square, desired_square)
    if (current_square.x > desired_square.x) && (current_square.y < desired_square.y)
      true
    else
      false
    end
  end

  def diagonal_down_left?(current_square, desired_square)
    if (current_square.x > desired_square.x) && (current_square.y > desired_square.y)
      true
    else
      false
    end
  end

  def horizontal_right?(current_square, desired_square)
    if current_square.x < desired_square.x
      true
    else
      false
    end
  end

  def horizontal_left?(current_square, desired_square)
    if current_square.x > desired_square.x
      true
    else
      false
    end
  end

  def up?(current_square, desired_square)
    if current_square.y < desired_square.y
      true
    else
      false
    end
  end

  def down?(current_square, desired_square)
    if current_square.y > desired_square.y
      true
    else
      false
    end
  end

  def pawn_advance_two_squares?
    pawn_out_two = false
    pawn_hash = @history.last_move["Pawn"]
    if @history.last_move.key? "Pawn" && pawn_hash[0].y == 7 && pawn_hash[1].y == 5
      pawn_out_two = true
    elsif @history.last_move.key? "Pawn" && pawn_hash[0].y == 2 && pawn_hash[1].y == 4
      pawn_out_two = true
    else
      pawn_out_two = false
    end
    pawn_out_two
  end

  def move_allowed?(current_square, desired_square, piece)
    #path_clear?(current_square, desired_square, piece.color)
    #!in_check?
    #valid_en_passant?(current_square, desired_square, piece)

  end

  def valid_en_passant?(current_square, desired_square, piece)
    if piece.class != Pawn
      false
    elsif pawn_advance_two_squares? && adjacent_to_piece?(desired_square, piece)
      true
    else
      false       
    end
  end

  def valid_short_castle?(player_color)
    if player_color == "white" && square_free?("f1") && square_free?("g1")
      true
    elsif player_color == "black" && square_free?("f8") && square_free?("g8")
      true
    else
      false
    end      
  end

  def castle_short_side(player)
    if player.color == "white"
      @square_hash["g1"].piece_on_square = player.king
      @square_hash["f1"].piece_on_square = player.short_side_rook
      @square_hash["e1"].piece_on_square = nil
      @square_hash["h1"].piece_on_square = nil
    elsif player.color == "black"
      @square_hash["g8"].piece_on_square = player.king
      @square_hash["f8"].piece_on_square = player.short_side_rook
      @square_hash["e8"].piece_on_square = nil
      @square_hash["h8"].piece_on_square = nil
    end
  end

  def castle_long_side(player)
    if player.color == "white"
      @square_hash["c1"].piece_on_square = player.king
      @square_hash["d1"].piece_on_square = player.short_side_rook
      @square_hash["e1"].piece_on_square = nil
      @square_hash["a1"].piece_on_square = nil
    elsif player.color == "black"
      @square_hash["c8"].piece_on_square = player.king
      @square_hash["d8"].piece_on_square = player.short_side_rook
      @square_hash["e8"].piece_on_square = nil
      @square_hash["a8"].piece_on_square = nil
    end
  end

  def valid_long_castle?(player_color)
    if player_color == "white" && square_free?("b1") && square_free?("c1") && square_free?("d1")
      true
    elsif player_color == "black" && square_free?("b8") && square_free?("c8") && square_free?("d8")
      true
    else
      false
    end
  end

  def adjacent_to_piece?(desired_square, piece)
    if piece.color == "white" && (@history.last_move["Pawn"][1].y == desired_square.y - 1)
      true
    elsif piece.color == "black" && (@history.last_move["Pawn"][1].y == desired_square.y + 1)
      true
    else
      false
    end
  end

  def path_clear?(current_square, desired_square, player_color)
    letters_hash = {1=>"a", 2=>"b", 3=>"c", 4=>"d", 5=>"e", 6=>"f", 7=>"g", 8=>"h"}
    path_clear = false
    if current_square.piece_type == Knight && (square_free?(desired_square.coordinates) || !same_color_on_square?(desired_square.coordinates, player_color))
      path_clear = true
    elsif current_square.piece_type == Knight && same_color_on_square?(desired_square.coordinates)
      puts "Piece(s) in way"
      path_clear = false
    elsif diagonal_up_right?(current_square, desired_square)
       (desired_square.x - current_square.x).times do |i| 
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
    elsif diagonal_down_right?(current_square, desired_square)
      (desired_square.x - current_square.x).times do |i| 
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
    elsif diagonal_down_left?(current_square, desired_square)
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
    elsif diagonal_up_left?(current_square, desired_square)
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
    elsif horizontal_left?(current_square, desired_square)
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
    elsif horizontal_right?(current_square, desired_square)
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
    elsif down?(current_square, desired_square) 
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
    elsif up?(current_square, desired_square)
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
      false
    end
  end
end

class History
  attr_accessor :snapshot, :last_move
  def initialize
    @snapshot = []
    @last_move = {}
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
        @player1.choose_player_piece(Queen).position = value.coordinates
      when "e1"
        value.piece_on_square = @player1.choose_player_piece(King)
        @player1.choose_player_piece(King).position = value.coordinates
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
        @player2.choose_player_piece(Queen).position = value.coordinates
      when "e8"
        value.piece_on_square = @player2.choose_player_piece(King)
        @player2.choose_player_piece(King).position = value.coordinates
      end
    end
  end

  def capture_piece(desired_square)
    current_player.captured_pieces << desired_square.piece_on_square
  end

  def remove_from_player_pieces(desired_square)
    opponent.pieces.delete_if {|i| i.position == desired_square.coordinates}
  end

  def play_game
    while @current_turn <= 5
      puts @board.square_hash
      move(current_player) #only structured for irb
      # while !@board.checkmate && !draw?
      #   move(current_player)
      #   puts @board
      #   @board.store_board
      # end
      @board.store_board
    end
    # print_game_result
  end

  def move(player) 
    puts "Which piece would you like to move '#{player.color} player'? (please choose a square ex: c2)
          \nIf you would like to 'castle', please type castle"
    choice = gets.chomp.downcase
    if choice == "castle"
      puts "Would you like to castle short (on the kingside) or long (on the queenside)
            \nplease type 'short' or 'long'"  
      castle_side = gets.chomp.downcase
      if castle_side == "short" && @board.valid_short_castle?(player.color) && player.pieces_on_initial_square?
        @board.castle_short_side(player) 
        @current_turn += 1 
      elsif castle_side == "long" && @board.valid_long_castle?(player.color) && player.pieces_on_initial_square?
        @board.castle_long_side(player)
        @current_turn += 1
      else
        puts "Unable to castle"
      end
    elsif @board.same_color_on_square?(choice, player.color)
      piece = @board.square_hash[choice].piece_on_square
      puts "To where would you like to move that #{piece.class}?"
      new_square = gets.chomp.downcase
      current_square = @board.square_hash[choice]
      desired_square = @board.square_hash[new_square]
      if !@board.square_free?(new_square) && current_player.valid_move?(current_square, desired_square, piece) && @board.path_clear?(current_square, desired_square, piece.color)
        capture_piece(desired_square)
        @board.store_move(current_square, desired_square)
        remove_from_player_pieces(desired_square)
        adjust_instance_methods(piece)
        @board.place_piece(current_square, desired_square)
        player.set_position(piece, desired_square)
        @current_turn += 1   
      elsif @board.square_free?(new_square) && current_player.valid_move?(current_square, desired_square, piece) && @board.path_clear?(current_square, desired_square, piece.color)
        @board.store_move(current_square, desired_square)
        adjust_instance_methods(piece)
        @board.place_piece(current_square, desired_square)
        player.set_position(piece, desired_square)
        @current_turn += 1
      elsif @current_turn > 1 && @board.square_free?(new_square) && @board.valid_en_passant?(current_square, desired_square, piece) && current_player.en_passant_move?(current_square, desired_square, piece)
        @board.store_move(current_square, desired_square)
        adjust_instance_methods(piece)
        @board.place_piece(current_square, desired_square)
        player.set_position(piece, desired_square)
        @current_turn += 1
      else
        puts "Invalid move, please choose again"
      end
      
    elsif @board.square_free?(choice)
      puts "You do not have a piece there, please choose again"
    end
  end

  def adjust_instance_methods(piece)
    if piece.class == Pawn || piece.class == Rook || piece.class == King
      piece.on_initial_square = false
    end
  end

  def current_player
    @current_turn.even? ? @player2 : @player1
  end

  def opponent
    @current_turn.even? ? @player1 : @player2
  end

  def draw?
    if threefold_repition? 
      true
    elsif stalemate?
      true
    elsif fifty_moves?
      true
    else
      false
    end
  end

  def stalemate?

  end

  def fifty_moves?

  end

  def threefold_repition?
    snapshot_array = @board.history.snapshot
    if snapshot_array.detect {|i| snapshot_array.count(i) > 3}
      true
    else
      false
    end
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
  attr_accessor :on_initial_square, :color
  def initialize(color)
    super(color)
    @on_initial_square = true
  end

  def get_valid_moves(current_square, desired_square)
    potentials = []
    if @on_initial_square && @color == "white"
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

  def get_en_passant_moves(current_square, desired_square)
    potentials = []
    if @color == "white"
      potentials.push(
        [current_square.x + 1, 6],
        [current_square.x - 1, 6]
        )
    elsif @color == "black"
      potentials.push(
        [current_square.x - 1, 3],
        [current_square.x + 1, 3]
        )
    end

    valid_children = potentials.select do |i|
      i[0].between?(0,8)
    end
    valid_children.include? [desired_square.x, desired_square.y]
  end
end

class Rook < Piece
  attr_accessor :on_initial_square
  def initialize(color)
    super(color)
    @on_initial_square = true
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
  attr_accessor :on_initial_square
  def initialize(color)
    super(color)
    @on_initial_square = true
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

