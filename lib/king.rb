class King < Piece
  attr_accessor :on_initial_square, :color, :valid_children
  def initialize(color)
    super(color)
    @on_initial_square = true
    case @color
    when "black"
      @unicode = "\u2654"
    when "white"
      @unicode = "\u265A"
    end

  end

  def self.get_valid_moves(from_square, to_square)
    potentials = []
    potentials.push(
      [from_square.x, from_square.y + 1],
      [from_square.x, from_square.y - 1],
      [from_square.x + 1, from_square.y],
      [from_square.x - 1, from_square.y],
      [from_square.x + 1, from_square.y + 1],
      [from_square.x - 1, from_square.y - 1],
      [from_square.x + 1, from_square.y - 1],
      [from_square.x - 1, from_square.y + 1]
      )

    valid_children = potentials.select do |i|
      i[0].between?(0,8) &&
      i[1].between?(0,8)
    end
    valid_children.include? [to_square.x, to_square.y]
  end
end