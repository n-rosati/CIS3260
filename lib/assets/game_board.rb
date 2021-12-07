class GameBoard
  # @param [Array<Array<Intersection>>] intersections
  def initialize(intersections)
    # Checks if all elements of `intersections` are Intersections
    unless intersections.is_a?(Array) && intersections.all? { |x| x.is_a?(Array) } && intersections.all? { |x| x.all? { |y| y.is_a?(Intersection) } }
      raise TypeError("First parameter must be 2D array of Intersection") unless intersections.is_a?(Array)
    end

    @intersections = []
    intersections.each { |i| i.each { |j| @intersections[j.get_x_as_integer][j.y - 1] = j }}
  end

  # Clears all Intersections of their Piece
  def clear_all_intersections
    # FIXME:
    #  Rubocop was saying Safe Navigation was not needed. If it is an issue, replace with:
    #  @intersections&.each { |i| i&.each { |j| j.clear if j.instance_of?(Intersection) }}
    @intersections&.each { |i| i.each { |j| j.clear if j.instance_of?(Intersection) }}
  end

  # @param [Integer] x Intersection x coordinate
  # @param [Integer] y Intersection y coordinate
  # @return [Boolean] True if Intersection (x, y) is empty, else false
  def is_empty_intersection(x, y)
    if !x.is_a?(Integer)
      raise TypeError("First parameter must be an integer")
    elsif !y.is_a?(Integer)
      raise TypeError("Second parameter must be an integer")
    end

    @intersections[x][y] == nil ? false : @intersections[x][y].is_occupied
  end

  # @param [Symbol] colour The colour to count Pieces for. Can be `:white` or `:black`
  # @return [Integer] Number of Pieces on the board belonging to the specified Player
  def count_pieces_on_board(colour)
    count = 0
    @intersections&.each do |i|
      i.each do |j|
        if j.instance_of?(Intersection) && j.get_occupant_colour? == colour
          ++count
        end
      end
    end

    count
  end

  # Moves the Piece to (x, y) from (piece_x, piece_y)
  # @param [Integer] x Destination Intersection x coordinate
  # @param [Integer] y Destination Intersection y coordinate
  # @param [Integer] piece_x Source Intersection x coordinate
  # @param [Integer] piece_y Source Intersection y coordinate
  def place_and_remove_piece(x, y, piece_x, piece_y)
    if !x.is_a?(Integer)
      raise TypeError("First parameter must be an integer")
    elsif !y.is_a?(Integer)
      raise TypeError("Second parameter must be an integer")
    elsif !piece_x.is_a?(Integer)
      raise TypeError("Third parameter must be an integer")
    elsif !piece_y.is_a?(Integer)
      raise TypeError("Fourth parameter must be an integer")
    end

    if @intersections[x] == nil
      raise ArgumentError("Invalid destination intersection x coordinate")
    elsif @intersections[x][y] == nil
      raise ArgumentError("Invalid destination intersection y coordinate")
    elsif @intersections[piece_x] == nil
      raise ArgumentError("Invalid source intersection x coordinate")
    elsif @intersections[piece_x][piece_y] == nil
      raise ArgumentError("Invalid source intersection y coordinate")
    end

    @intersections[x][y].place_occupant(@intersections[piece_x][piece_y].take_occupant)
  end

  # @param [Integer] x Intersection x coordinate
  # @param [Integer] y Intersection y coordinate
  # @param [Piece] piece Piece to place on the board
  def place_piece(x, y, piece)
    if !x.is_a?(Integer)
      raise TypeError("First parameter must be a integer")
    elsif !y.is_a?(Integer)
      raise TypeError("Second parameter must be a integer")
    elsif piece.instance_of?(Piece)
      raise TypeError("Third parameter must be an instance of Piece")
    end

    if @intersections[x] == nil
      raise ArgumentError("Invalid intersection x coordinate")
    elsif @intersections[x][y] == nil
      raise ArgumentError("Invalid intersection y coordinate")
    end

    @intersections[x][y].place_occupant(piece)
  end

  # @param [Integer] x Intersection x coordinate
  # @param [Integer] y Intersection y coordinate
  def remove_piece(x, y)
    if !x.is_a?(Integer)
      raise TypeError("First parameter must be a integer")
    elsif !y.is_a?(Integer)
      raise TypeError("Second parameter must be a integer")
    end

    if @intersections[x] == nil
      raise ArgumentError("Invalid intersection x coordinate")
    elsif @intersections[x][y] == nil
      raise ArgumentError("Invalid intersection y coordinate")
    end

    @intersections[x][y].clear
  end

  # @param [Symbol] turn_colour The colour of the Player who's turn it is. Can be `:white` or `:black`
  # @param [Integer] x Intersection x coordinate
  # @param [Integer] y Intersection y coordinate
  # @return [Boolean] True if the occupant colour of Intersection (x,y) and turn_colour match, else false
  def check_occupant_colour_matches_turn(turn_colour, x, y)
    if turn_colour != :white && turn_colour != :black
      raise TypeError("First parameter must be :black or :white")
    elsif !x.is_a?(Integer)
      raise TypeError("Second parameter must be a integer")
    elsif !y.is_a?(Integer)
      raise TypeError("Third parameter must be a integer")
    end

    if @intersections[x] == nil
      raise ArgumentError("Invalid intersection x coordinate")
    elsif @intersections[x][y] == nil
      raise ArgumentError("Invalid intersection y coordinate")
    end

    @intersections[x][y].get_occupant_colour? == turn_colour
  end

  # @param [Symbol] colour Colour of the Piece to check
  # @param [Integer] x Intersection x coordinate
  # @param [Integer] y Intersection y coordinate
  # @return [Boolean] True if the Piece at Intersection (x, y) is in a mill
  def is_piece_in_mill(colour, x, y)
    if colour != :white && colour != :black
      raise TypeError("First parameter must be :black or :white")
    elsif !x.is_a?(Integer)
      raise TypeError("Second parameter must be a integer")
    elsif !y.is_a?(Integer)
      raise TypeError("Third parameter must be a integer")
    end

    if @intersections[x] == nil
      raise ArgumentError("Invalid intersection x coordinate")
    elsif @intersections[x][y] == nil
      raise ArgumentError("Invalid intersection y coordinate")
    end

    piece_in_vertical_mill = true
    piece_in_horizontal_mill = true

    if x == 3
      if y < 3
        (0..3).each { |i|
          if @intersections[x] != nil && @intersections[x][i] != nil
            if @intersections[x][i].get_occupant_colour? != colour
              piece_in_vertical_mill = false
            end
          end
        }
      else
        (4..7).each { |i|
          if @intersections[x] != nil && @intersections[x][i] != nil
            if @intersections[x][i].get_occupant_colour? != colour
              piece_in_vertical_mill = false
            end
          end
        }
      end

      (0..7).each { |i|
        if @intersections[i] != nil && @intersections[i][y] != nil
          if @intersections[i][y].get_occupant_colour? != colour
            piece_in_horizontal_mill = false
          end
        end
      }
    elsif y ==3
      if x < 3
        (0..3).each { |i|
          if @intersections[i] != nil && @intersections[i][y] != nil
            if @intersections[i][y].get_occupant_colour? != colour
              piece_in_horizontal_mill = false
            end
          end
        }
      else
        (4..6).each { |i|
          if @intersections[i] != nil && @intersections[i][y] != nil
            if @intersections[i][y].get_occupant_colour? != colour
              piece_in_horizontal_mill = false
            end
          end
        }
      end
      (0..7).each { |i|
        if @intersections[i] != nil && @intersections[i][y] != nil
          if @intersections[i][y].get_occupant_colour? != colour
            piece_in_vertical_mill = false
          end
        end
      }
    else
      (0..7).each { |i|
        if @intersections[x] != nil && @intersections[x][i] != nil
          if @intersections[x][i].get_occupant_colour? != colour
            piece_in_vertical_mill = false
          end
        end
      }
      (0..7).each { |i|
        if @intersections[x] != nil && @intersections[x][i] != nil
          if @intersections[x][i].get_occupant_colour? != colour
            piece_in_vertical_mill = false
          end
        end
      }
      (0..7).each { |i|
        if @intersections[i] != nil && @intersections[i][y] != nil
          if @intersections[i][y].get_occupant_colour? != colour
            piece_in_horizontal_mill = false
          end
        end
      }
    end

    piece_in_horizontal_mill || piece_in_vertical_mill
  end

  # Searches the board to find if there is a Piece of a specified colour that is not in a mill
  # @param [Symbol] colour Colour of the Pieces to search for
  # @return [Boolean] True if there is a Piece on the board that is of the specified colour and not in a mill, else false
  def exist_piece_not_in_mill(colour)
    retval = false
    @intersections&.each do |i|
      i.each do |j|
        if @intersections[i][j].get_occupant_colour? == colour
          retval = true unless is_piece_in_mill(colour, i, j)
        end
      end
    end

    retval
  end
end
