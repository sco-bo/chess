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