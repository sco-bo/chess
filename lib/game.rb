class Game
  attr_accessor :board, :mock_hash #only doing this for irb tests
  def initialize
    @player1 = Player.new("white")
    @player2 = Player.new("black")
    @board = Board.new
    set_opening_positions
    initialize_mock_hash
    @current_turn = 1
  end

  def initialize_mock_hash
    @mock_hash = @board.deep_copy(@board.square_hash)
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

  def capture_piece(to_square)
    current_player.captured_pieces << to_square.piece_on_square
  end

  def capture_en_passant(opponent_pawn_square)
    capture_piece(opponent_pawn_square)
    opponent_pawn_square.piece_on_square = nil    
  end

  def remove_from_player_pieces(to_square)
    opponent.pieces.delete_if {|i| i.position == to_square.coordinates}
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

  def square_under_attack?(square)
    opponent.pieces.any? do |i|
      opponent.valid_move?(@board.square_hash[i.position], @board.square_hash[square], i)
    end
  end

  def threatening_piece(square)
    opponent.pieces.find do |i|
      opponent.valid_move?(@board.square_hash[i.position], @board.square_hash[square], i)   
    end
  end

  def put_in_check?
    if square_under_attack?(current_player.king.position) &&  @board.path_clear?(@mock_hash[threatening_piece(current_player.king.position).position], @mock_hash[current_player.king.position], opponent.color, @mock_hash) 
      true
    else
      false
    end
  end

  def mock_move(from_square, to_square)
    @board.place_piece(from_square, to_square)
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
      mock_move(@mock_hash[choice], @mock_hash[new_square])
      from_square = @board.square_hash[choice]
      to_square = @board.square_hash[new_square]
      if !@board.square_free?(new_square) && player.valid_move?(from_square, to_square, piece) && @board.path_clear?(from_square, to_square, piece.color) && !put_in_check?
        capture_piece(to_square)
        @board.store_move(from_square, to_square)
        remove_from_player_pieces(to_square)
        adjust_instance_methods(piece)
        @board.place_piece(from_square, to_square)
        player.set_position(piece, to_square)
        @current_turn += 1   
      elsif @board.square_free?(new_square) && player.valid_move?(from_square, to_square, piece) && @board.path_clear?(from_square, to_square, piece.color) && !put_in_check?
        @board.store_move(from_square, to_square)
        adjust_instance_methods(piece)
        @board.place_piece(from_square, to_square)
        player.set_position(piece, to_square)
        @current_turn += 1
      elsif @current_turn > 1 && player.en_passant_move?(from_square, to_square, piece) && @board.square_free?(new_square) && @board.valid_en_passant?(from_square, to_square, piece) && !put_in_check?
        capture_en_passant(@board.history.last_move["Pawn"][1])
        remove_from_player_pieces(@board.history.last_move["Pawn"][1])
        @board.store_move(from_square, to_square)
        @board.place_piece(from_square, to_square)
        player.set_position(piece, to_square)
        @current_turn += 1
      else
        puts "Invalid move, please choose again"
        initialize_mock_hash
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