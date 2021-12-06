class Bag
  def initialize
    @pieces = []
  end

  def select_piece
    @pieces.pop
  end

  def store_piece(piece)
    unless piece.instance_of?(Piece)
      raise TypeError("Parameter `piece` must be instance of Piece")
    end

    @pieces.push(piece)
  end

  def is_empty
    @pieces.empty?
  end

  def empty_bag
    @pieces.clear
  end
end
