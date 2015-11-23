class Player
  attr_accessor :color, :captured_pieces

  def initialize(color)
    @color = color
    @captured_pieces = []
  end
end

class Board
  def initialize
    @spaces = {
      a8: "bR", 
      b8: "bN", 
      c8: "bB", 
      d8: "bQ", 
      e8: "bK", 
      f8: "bB",
      g8: "bN", 
      h8: "bR",
      a7: "bP",
      b7: "bP",
      c7: "bP",
      d7: "bP",
      e7: "bP",
      f7: "bP",
      g7: "bP",
      h7: "bP",
      a6: nil,
      b6: nil,
      c6: nil,
      d6: nil,
      e6: nil,
      f6: nil,
      g6: nil,
      h6: nil,
      a5: nil,
      b5: nil,
      c5: nil,
      d5: nil,
      e5: nil,
      f5: nil,
      g5: nil,
      h5: nil,
      a4: nil,
      b4: nil,
      c4: nil,
      d4: nil,
      e4: nil,
      f4: nil,
      g4: nil,
      h4: nil,
      a3: nil,
      b3: nil,
      c3: nil,
      d3: nil,
      e3: nil,
      f3: nil,
      g3: nil,
      h3: nil,
      a2: "wP",
      b2: "wP",
      c2: "wP",
      d2: "wP",
      e2: "wP",
      f2: "wP",
      g2: "wP",
      h2: "wP",
      a1: "wR",
      b1: "wN",
      c1: "wB",
      d1: "wQ",
      e1: "wK",
      f1: "wB",
      g1: "wN",
      h1: "wR",
    }
    
  end

  def to_s
    output = "8 "
    @spaces.each_with_index do |(key, value), index|
      output << "#{value || "**"}"
      case index % 8
      when 0,1,2,3,4,5,6 then output << " | "
      when 7 then output << "\n  --------------------------------------\n" + (key[1].to_i - 1).to_s + " " unless index == 63
      end
    end
    output << "\n  a    b    c    d    e    f    g    h"
    output
  end

end

class Game
  def initialize
    @board = Board.new
  end

  def play_game
    puts @board
  end

end

Game.new.play_game
