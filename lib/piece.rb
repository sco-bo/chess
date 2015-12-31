class Piece
  attr_accessor :color, :unicode, :position
  def initialize(color, position=nil)
    @color = color
    @position = position
  end
end