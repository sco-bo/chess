class Bishop < Piece
  def initialize(color)
    super(color)
  end

  def self.get_valid_moves(from_square, to_square)
    potentials = []
    potentials.push(
      [from_square.x + 1, from_square.y + 1],
      [from_square.x + 2, from_square.y + 2],
      [from_square.x + 3, from_square.y + 3],
      [from_square.x + 4, from_square.y + 4],
      [from_square.x + 5, from_square.y + 5],
      [from_square.x + 6, from_square.y + 6],
      [from_square.x + 7, from_square.y + 7],
      [from_square.x - 1, from_square.y + 1],
      [from_square.x - 2, from_square.y + 2],
      [from_square.x - 3, from_square.y + 3],
      [from_square.x - 4, from_square.y + 4],
      [from_square.x - 5, from_square.y + 5],
      [from_square.x - 6, from_square.y + 6],
      [from_square.x - 7, from_square.y + 7],
      [from_square.x + 1, from_square.y - 1],
      [from_square.x + 2, from_square.y - 2],
      [from_square.x + 3, from_square.y - 3],
      [from_square.x + 4, from_square.y - 4],
      [from_square.x + 5, from_square.y - 5],
      [from_square.x + 6, from_square.y - 6],
      [from_square.x + 7, from_square.y - 7],
      [from_square.x - 1, from_square.y - 1],
      [from_square.x - 2, from_square.y - 2],
      [from_square.x - 3, from_square.y - 3],
      [from_square.x - 4, from_square.y - 4],
      [from_square.x - 5, from_square.y - 5],
      [from_square.x - 6, from_square.y - 6],
      [from_square.x - 7, from_square.y - 7]
      )

    valid_children = potentials.select do |i|
      i[0].between?(0,8) &&
      i[1].between?(0,8)
    end
    valid_children.include? [to_square.x, to_square.y]
  end
end