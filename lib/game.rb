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