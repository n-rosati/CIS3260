class Referee
  # Create a new Referee
  # @param [GameBoard] board The board being used for the game
  # @param [Symbol] turn_colour The colour of the current Player's turn, `:white` or `:black`
  def initialize(board, turn_colour)
    if !player1.instance_of?(GameBoard)
      raise TypeError("First parameter must be an instance of GameBoard")
    elsif turn_colour != :white && turn_colour != :black
      raise TypeError("Fourth parameter must be :white or :black")
    end
    @board = board
    @turn_colour = turn_colour
  end

  # Checks if the intersection that the move is occuring to is empty
  # @param [Integer] x The x coordinate to check for a valid move
  # @param [Integer] y The y coordinate to check for a valid move
  def validatePlacement(x, y)
    if @board.is_empty_intersection[x,y]
      true
    else
      false
    end
  end

  # Checks if the intersection that the move is occuring to is empty, and a :move
  # @param [Integer] x The x coordinate to check for a valid move
  # @param [Integer] y The y coordinate to check for a valid move
  # @param [Integer] piece_x The x coordinate of the piece being moved
  # @param [Integer] piece_y The y coordinate of the piece being moved
  def validateMove(x, y, piece_x, piece_y)
    if @board.is_empty_intersection[x,y]
      if @board.check_occupant_colour_matches_turn(@turn_colour, piece_x, piece_y)
        if determineMovementType(x, y, piece_x, piece_y) == :move
          return true
        end
      end
    end
    false
  end

  # Checks if the intersection that the move is occuring to is empty, and player has 3 pieces remaining
  # @param [Integer] x The x coordinate to check for a valid fly
  # @param [Integer] y The y coordinate to check for a valid fly
  # @param [Integer] piece_x The x coordinate of the piece being flown
  # @param [Integer] piece_y The y coordinate of the piece being flown
  def validateFly(x, y, piece_x, piece_y)
    if @board.is_empty_intersection[x,y]
      if @board.check_occupant_colour_matches_turn(@turn_colour, piece_x, piece_y)
        if @board.count_pieces_on_board(@turn_colour) == 3
          return true
        end
      end
    end
    false
  end

  # Checks to ensure the piece being captured is not the capturing player's colour and not in a mill (unless all pieces are in a mill)
  # @param [Integer] x The x coordinate to check for a valid capture
  # @param [Integer] y The y coordinate to check for a valid capture
  def validateCapture(x, y)
    if(@turn_colour == :white)
      opposite_colour = :black
    else
      opposite_colour = :white
    end
    # If there are no pieces not in a mill, any removal of the opposite colour's pieces is valid
    if !@board.exist_piece_not_in_mill(@opposite_colour)
      if !@board.is_empty_intersection[x,y]
        if !@board.check_occupant_colour_matches_turn(@turn_colour, x, y)
          return true
        end
      end
    else
      # If there are pieces that aren't in a mill, must remove one of those pieces 
      if !@board.is_empty_intersection[x,y]
        if !@board.check_occupant_colour_matches_turn(@turn_colour, x, y)
          if !is_piece_in_mill(@opposite_colour, x, y)
            return true
          end
        end
      end
    end
    false
  end

  # Checks if the player has formed a mill
  # @param [Integer] x The x coordinate to check for a mill
  # @param [Integer] y The y coordinate to check for a mill
  def validateMill(x, y)
    if is_piece_in_mill(@turn_colour, x, y)
      true
    else
      false
    end
  end

  # Determine if the player is attempting a 'fly' or a regular 'move'
  # @param [Integer] x The destination x coordinate to check for the movement type
  # @param [Integer] y The destination y coordinate to check for the movement type
  # @param [Integer] piece_x The x coordinate of the piece being moved
  # @param [Integer] piece_y The y coordinate of the piece being moved
  def determineMovementType(x, y, piece_x, piece_y)
    # Pain
    # x = 0 start
    if piece_x == 0 && piece_y == 0 && x == 0 && y == 3
      return :move
    elsif piece_x == 0 && piece_y == 0 && x == 3 && y == 0
      return :move
    elsif piece_x == 0 && piece_y == 3 && x == 0 && y == 0
      return :move
    elsif piece_x == 0 && piece_y == 3 && x == 0 && y == 6
      return :move
    elsif piece_x == 0 && piece_y == 3 && x == 1 && y == 3
      return :move
    elsif piece_x == 0 && piece_y == 6 && x == 0 && y == 3
      return :move
    elsif piece_x == 0 && piece_y == 6 && x == 3 && y == 6
      return :move
    # x = 1 start
    elsif piece_x == 1 && piece_y == 1 && x == 1 && y == 3
      return :move
    elsif piece_x == 1 && piece_y == 1 && x == 3 && y == 1
      return :move
    elsif piece_x == 1 && piece_y == 3 && x == 0 && y == 3
      return :move
    elsif piece_x == 1 && piece_y == 3 && x == 1 && y == 1
      return :move
    elsif piece_x == 1 && piece_y == 3 && x == 1 && y == 5
      return :move
    elsif piece_x == 1 && piece_y == 3 && x == 2 && y == 3
      return :move
    elsif piece_x == 1 && piece_y == 5 && x == 1 && y == 3
      return :move
    elsif piece_x == 1 && piece_y == 5 && x == 3 && y == 5
      return :move
    # x = 2 start
    elsif piece_x == 2 && piece_y == 2 && x == 2 && y == 3
      return :move
    elsif piece_x == 2 && piece_y == 2 && x == 3 && y == 2
      return :move
    elsif piece_x == 2 && piece_y == 3 && x == 2 && y == 2
      return :move
    elsif piece_x == 2 && piece_y == 3 && x == 2 && y == 4
      return :move
    elsif piece_x == 2 && piece_y == 3 && x == 1 && y == 3
      return :move
    elsif piece_x == 2 && piece_y == 4 && x == 2 && y == 3
      return :move
    elsif piece_x == 2 && piece_y == 4 && x == 3 && y == 4
      return :move
    # x = 3 start
    elsif piece_x == 3 && piece_y == 0 && x == 0 && y == 0
      return :move
    elsif piece_x == 3 && piece_y == 0 && x == 6 && y == 0
      return :move
    elsif piece_x == 3 && piece_y == 0 && x == 3 && y == 1
      return :move
    elsif piece_x == 3 && piece_y == 1 && x == 3 && y == 0
      return :move
    elsif piece_x == 3 && piece_y == 1 && x == 1 && y == 1
      return :move
    elsif piece_x == 3 && piece_y == 1 && x == 5 && y == 1
      return :move
    elsif piece_x == 3 && piece_y == 1 && x == 3 && y == 2
      return :move
    elsif piece_x == 3 && piece_y == 2 && x == 2 && y == 2
      return :move
    elsif piece_x == 3 && piece_y == 2 && x == 4 && y == 2
      return :move
    elsif piece_x == 3 && piece_y == 2 && x == 3 && y == 1
      return :move
    elsif piece_x == 3 && piece_y == 4 && x == 2 && y == 4
      return :move
    elsif piece_x == 3 && piece_y == 4 && x == 4 && y == 4
      return :move
    elsif piece_x == 3 && piece_y == 4 && x == 3 && y == 5
      return :move
    elsif piece_x == 3 && piece_y == 5 && x == 3 && y == 4
      return :move
    elsif piece_x == 3 && piece_y == 5 && x == 1 && y == 5
      return :move
    elsif piece_x == 3 && piece_y == 5 && x == 5 && y == 5
      return :move
    elsif piece_x == 3 && piece_y == 5 && x == 3 && y == 6
      return :move
    elsif piece_x == 3 && piece_y == 6 && x == 0 && y == 6
      return :move
    elsif piece_x == 3 && piece_y == 6 && x == 6 && y == 6
      return :move
    elsif piece_x == 3 && piece_y == 6 && x == 3 && y == 5
      return :move
    # x = 4 start
    elsif piece_x == 4 && piece_y == 2 && x == 3 && y == 2
      return :move
    elsif piece_x == 4 && piece_y == 2 && x == 4 && y == 3
      return :move
    elsif piece_x == 4 && piece_y == 3 && x == 5 && y == 3
      return :move
    elsif piece_x == 4 && piece_y == 3 && x == 4 && y == 2
      return :move
    elsif piece_x == 4 && piece_y == 3 && x == 4 && y == 4
      return :move
    elsif piece_x == 4 && piece_y == 4 && x == 3 && y == 4
      return :move
    elsif piece_x == 4 && piece_y == 4 && x == 4 && y == 3
      return :move
    # x = 5 start
    elsif piece_x == 5 && piece_y == 1 && x == 3 && y == 1
      return :move
    elsif piece_x == 5 && piece_y == 1 && x == 5 && y == 3
      return :move
    elsif piece_x == 5 && piece_y == 3 && x == 5 && y == 1
      return :move
    elsif piece_x == 5 && piece_y == 3 && x == 5 && y == 5
      return :move
    elsif piece_x == 5 && piece_y == 3 && x == 4 && y == 3
      return :move
    elsif piece_x == 5 && piece_y == 3 && x == 6 && y == 3
      return :move
    elsif piece_x == 5 && piece_y == 5 && x == 3 && y == 5
      return :move
    elsif piece_x == 5 && piece_y == 5 && x == 5 && y == 3
      return :move
    # x = 6 start
    elsif piece_x == 6 && piece_y == 0 && x == 3 && y == 0
      return :move
    elsif piece_x == 6 && piece_y == 0 && x == 6 && y == 3
      return :move
    elsif piece_x == 6 && piece_y == 3 && x == 6 && y == 6
      return :move
    elsif piece_x == 6 && piece_y == 3 && x == 5 && y == 3
      return :move
    elsif piece_x == 6 && piece_y == 3 && x == 6 && y == 0
      return :move
    elsif piece_x == 6 && piece_y == 6 && x == 3 && y == 6
      return :move
   elsif piece_x == 6 && piece_y == 6 && x == 6 && y == 3
      return :move
    # If none of the above movements were made, it was a fly
    else
      return :fly
    end
  end

  # Check if the opposing player has less than 3 pieces remaining
  def checkWin()
    if(@turn_colour == :white)
      if @board.countPiecesOnBoard(:black) < 3
        return true
      end
    else
      if @board.countPiecesOnBoard(:white) < 3
        return true
      end
    end
    false
  end

end