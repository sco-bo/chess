class History
  attr_accessor :snapshot, :last_move
  def initialize
    @snapshot = []
    @last_move = {}
  end
end