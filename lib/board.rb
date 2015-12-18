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