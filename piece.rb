class Piece
  def initialize(colour)
    if colour != :white || colour != :black
      raise TypeError("Parameter `colour` must be :white or :black")
    end

    @colour = colour
  end

  def get_colour?
    @colour
  end
end
