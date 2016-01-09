class Game
  attr_accessor :board, :mock_hash #only doing this for irb tests
  def initialize
    @player1 = Player.new("white")
    @player2 = Player.new("black")
    @board = Board.new
    set_opening_positions
    refresh_mock_hash
    @current_turn = 1
  end

  def refresh_mock_hash
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
        @player1.choose_player_piece(Bishop).origin = value.coordinates
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
        @player2.choose_player_piece(Bishop).origin = value.coordinates
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
    while !checkmate? && !draw?
      puts @board
      move(current_player)
      refresh_mock_hash
      @board.store_board
    end
    print_game_result
  end

  def square_under_attack?(square)
    @mock_hash.any? do |k,v|
      !v.piece_on_square.nil? && v.piece_on_square.color == opponent.color && move_ok?(opponent, @mock_hash[k], @mock_hash[square], v.piece_on_square, @mock_hash) 
    end
  end

  def checkmate?
    if !move_available? && square_under_attack?(mock_king_position)
     true
   else
    false
    end
  end

  def stalemate?
    if !move_available? && !square_under_attack?(mock_king_position)
      true
    else
      false
    end
  end

  def move_available?
    current_player.pieces.each do |i|
      @mock_hash.each do |k,v|
        next if @mock_hash[i.position] == @mock_hash[k] || k == mock_king_position
        mock_move(@mock_hash[i.position], @mock_hash[k]) 
        @available_move = false
        if move_ok?(current_player, @board.square_hash[i.position], @board.square_hash[k], i) 
          refresh_mock_hash
          @available_move = true
          break @available_move
        else
          refresh_mock_hash
        end
      end
      break if @available_move 
    end
    @available_move
  end

  def castle_through_attack?(player_color, castle_side)
    if player_color == "white" && castle_side == "short" && !square_under_attack?("e1") && !square_under_attack?("f1") && !square_under_attack?("g1")
      false
    elsif player_color == "white" && castle_side == "long" && !square_under_attack?("e1") && !square_under_attack?("d1") && !square_under_attack?("c1")
      false  
    elsif player_color == "black" && castle_side == "short" && !square_under_attack?("e8") && !square_under_attack?("f8") && !square_under_attack?("g8")
      false
    elsif player_color == "black" && castle_side == "long" && !square_under_attack?("e8") && !square_under_attack?("d8") && !square_under_attack?("c8")
      false
    else
      true
    end
  end

  def mock_king_position
    @mock_hash.find {|k,v| v.piece_on_square.class == King && v.piece_on_square.color == current_player.color}[0]
  end

  def mock_move(from_square, to_square)
    @board.place_piece(from_square, to_square) 
  end

  def move_ok?(player, from_square, to_square, piece, board=@board.square_hash)
    if player == current_player
      return player.valid_move?(from_square, to_square, piece) && @board.path_clear?(from_square, to_square, piece.color, board) && !square_under_attack?(mock_king_position)
    elsif player == opponent
      return opponent.valid_move?(from_square, to_square, piece) && @board.path_clear?(from_square, to_square, piece.color, board)
    end
  end

  def castle_ok?(player, castle_side)
    return player.pieces_on_initial_square? && !castle_through_attack?(player.color, castle_side)
  end

  def move(player) 
    puts "Which piece would you like to move '#{player.color} player'? (please choose a square ex: c2)
          \nIf you would like to 'castle', please type castle"
    choice = gets.chomp.downcase
    if @board.square_hash[choice].nil?
      puts "Error. Please choose again"
    elsif choice == "castle"
      puts "Would you like to castle short (on the kingside) or long (on the queenside)
            \nplease type 'short' or 'long'"  
      castle_side = gets.chomp.downcase
      if castle_side == "short" && @board.valid_castle?(castle_side, player.color) && castle_ok?(player, castle_side) 
        @board.castle(castle_side, player)
        adjust_instance_methods(player.king)
        adjust_instance_methods(player.short_side_rook)
        player.set_position(player.king, new_short_king_position)
        player.set_position(player.short_side_rook, new_short_rook_position)
        @current_turn += 1 
      elsif castle_side == "long" && @board.valid_castle?(castle_side, player.color) && castle_ok?(player, castle_side) 
        @board.castle(castle_side, player)
        adjust_instance_methods(player.king)
        adjust_instance_methods(player.long_side_rook)
        player.set_position(player.king, new_long_king_position)
        player.set_position(player.long_side_rook, new_long_rook_position)
        @current_turn += 1
      else
        puts "Unable to castle"
      end
    elsif @board.same_color_on_square?(choice, player.color)
      piece = @board.square_hash[choice].piece_on_square
      puts "To where would you like to move that #{piece.class}?"
      new_square = gets.chomp.downcase
      mock_move(@mock_hash[choice], @mock_hash[new_square]) unless @board.square_hash[new_square].nil?
      @mock_hash[new_square].piece_on_square.position = new_square unless @board.square_hash[new_square].nil?
      from_square = @board.square_hash[choice]
      to_square = @board.square_hash[new_square]
      if @board.square_hash[new_square].nil?
        puts "Error. Please choose again"
      elsif !@board.square_free?(new_square) && move_ok?(player, from_square, to_square, piece) 
        capture_piece(to_square)
        @board.store_move(from_square, to_square)
        remove_from_player_pieces(to_square)
        adjust_instance_methods(piece)
        @board.place_piece(from_square, to_square)
        player.set_position(piece, to_square)
        @current_turn += 1   
      elsif @board.square_free?(new_square) && move_ok?(player, from_square, to_square, piece) 
        @board.store_move(from_square, to_square)
        adjust_instance_methods(piece)
        @board.place_piece(from_square, to_square)
        player.set_position(piece, to_square)
        @current_turn += 1
      elsif @current_turn > 1 && player.en_passant_move?(from_square, to_square, piece) && @board.square_free?(new_square) && @board.valid_en_passant?(from_square, to_square, piece) && !square_under_attack?(mock_king_position)
        capture_en_passant(@board.history.last_move["Pawn"][1])
        remove_from_player_pieces(@board.history.last_move["Pawn"][1])
        @board.store_move(from_square, to_square)
        @board.place_piece(from_square, to_square)
        player.set_position(piece, to_square)
        @current_turn += 1
      else
        puts "Invalid move, please choose again"
        refresh_mock_hash
      end
      if @board.pawn_promotion?
        puts "Your pawn is eligible for promotion
              \nTo what piece would you like to promote that pawn (Knight, Bishop, Rook, Queen)"
        new_piece = gets.chomp.capitalize
        player.promote_pawn(to_square, new_piece)
      end
    elsif @board.square_free?(choice) || !@board.same_color_on_square?(choice, player.color)
      puts "You do not have a piece there, please choose again" 
    end
  end

  def new_short_king_position
    @current_turn.even? ? @board.square_hash["g8"] : @board.square_hash["g1"]
  end

  def new_short_rook_position
    @current_turn.even? ? @board.square_hash["f8"] : @board.square_hash["f1"]
  end

  def new_long_king_position
    @current_turn.even? ? @board.square_hash["c8"] : @board.square_hash["c1"]
  end

  def new_long_rook_position
    @current_turn.even? ? @board.square_hash["d8"] : @board.square_hash["d1"]
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

  def print_game_result
    if checkmate? 
      puts @board
      puts "Checkmate by #{opponent.color} player"
      puts "Game Over"
    elsif draw?
      puts @board
      puts "This game is a draw"
    end
  end

  def draw?
    if threefold_repetition? 
      true
    elsif stalemate?
      true
    elsif fifty_moves?
      true
    elsif insufficient_material?
      true
    else
      false
    end
  end

  def no_pawns?
    return current_player.pieces.none? {|i| i.class == Pawn} && opponent.pieces.none? {|i| i.class == Pawn}
  end

  def only_kings?
    return current_player.pieces.all? {|i| i.class == King} && opponent.pieces.all? {|i| i.class == King}
  end

  def only_king_and_knight_or_bishop? 
    if current_player.pieces.all? {|i| i.class == King} && opponent.pieces.length == 2 && opponent.knight_and_king_only?
      true   
    elsif current_player.pieces.length == 2 && current_player.knight_and_king_only? && opponent.pieces.all? {|i| i.class == King}
      true
    elsif current_player.pieces.all? {|i| i.class == King} && opponent.pieces.length == 2 && opponent.bishop_and_king_only?
      true
    elsif current_player.pieces.length == 2 && current_player.bishop_and_king_only? && opponent.pieces.all? {|i| i.class == King}
      true
    else
      false
    end
  end

  def bishops_same_color? #revisit this, could be made a bit more DRY
    if current_player.bishop_origin == "c1" && opponent.bishop_origin == "f8"
      true
    elsif current_player.bishop_origin == "f8" && opponent.bishop_origin == "c1"
      true
    elsif current_player.bishop_origin == "f1" && opponent.bishop_origin == "c8"
      true
    elsif current_player.bishop_origin == "c8" && opponent.bishop_origin == "f1"
      true
    else
      false
    end
  end

  def bishops_kings? 
    if current_player.pieces.length == 2 && current_player.bishop_and_king_only? && opponent.pieces.length == 2 && opponent.pieces.bishop_and_king_only?
      true
    else
      false
    end
  end

  def insufficient_material? 
    if (no_pawns? && only_kings?) || (no_pawns? && only_king_and_knight_or_bishop?) || (bishops_kings? && bishops_same_color?)
      true
    else
      false
    end
  end

  def fifty_moves?
    snapshot_array = @board.history.snapshot
    if snapshot_array.length > 50 && snapshot_array.last.values.count(nil) == snapshot_array[-50].values.count(nil) && (snapshot_array.last.reject {|_,v| v != "Pawn"} == snapshot_array[-50].reject {|_,v| v != "Pawn"})
      true
    else
      false
    end
  end

  def threefold_repetition?
    snapshot_array = @board.history.snapshot
    if snapshot_array.detect {|i| snapshot_array.count(i) > 3} && snapshot_array.each_with_index.none? {|x,index| x == snapshot_array[index + 1]}
      true
    else
      false
    end
  end
end