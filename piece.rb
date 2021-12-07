class Piece
  # Creates a new Piece
  # @param [Symbol] colour The colour of the Piece to create. Can be either `:white` or `:black`
  def initialize(colour)
    if colour != :white && colour != :black
      raise TypeError("Parameter must be :white or :black")
    end

    @colour = colour
  end

  # @return [Symbol] The colour of the Piece
  def get_colour
    @colour
  end
end
