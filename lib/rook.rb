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