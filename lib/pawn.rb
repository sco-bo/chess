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