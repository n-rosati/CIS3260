class Game
  # Creates a new Game
  # @param [Player] x Intersection x coordinate
  # @param [Player] y Intersection y coordinate
  # @param [Symbol] phase The current phase of the game, `:place` or `:move`
  # @param [Symbol] colour The colour of the current Player's turn, `:white` or `:black`
  def initialize(player1, player2, phase, turn_colour)
    if !player1.instance_of?(Player)
      raise TypeError("First parameter must be an instance of Player")
    elsif !player2.instance_of?(Player)
      raise TypeError("Second parameter must be an instance of Player")
    elsif phase != :place && phase != :move
      raise TypeError("Third parameter must be :place or :move")
    elsif turn_colour != :white && turn_colour != :black
      raise TypeError("Fourth parameter must be :white or :black")
	end

    @player1 = player1
    @player2 = player2
    @phase = phase
    @turn_colour = turn_colour
    @ref = Referee.new()
    @winner = nil
    @draw_flag = :unset
  end

  # Places everything in the initial states needed to start a game
  def setup
    if rand(1) == 1
      @player1.colour = :white
      @player2.colour = :black
    else
      @player1.colour = :black
      @player2.colour = :white
    end
    @turn_colour = :white
    @phase = :place
  end

  # Update the game state such that it is the opposite player's turn
  def nextTurn
    if(turn_colour == :white)
      @turn_colour = :black
    elsif(turn_colour == :black)
      @turn_colour = :white
    end
    if(phase == :place)
      if(player1.is_bag_empty && player2.is_bag_empty)
        nextPhase
      end
    end
  end

  # Returns the turn colour
  def getTurnColour?
    @turn_colour
  end

  # Returns the current phase
  def getPhase?
    @phase
  end

  # Changes the phase of the game to move
  def nextPhase
    @phase = :move
  end

  # Sets the game's winner based on the current player's turn
  def endGame
    if(turn_colour == :white)
      @winner = :white
    elsif(turn_colour == :black)
      @winner = :black
    end
  end

  # Sets the flag requesting a draw
  def proposeDraw
    @draw_flag = :set
  end

  # Provides a reponse to a requested draw
  # @param [String] response The string response provided to an offered draw. Should be "accept" or "decline"
  def respondDraw(response)
    if(!@draw_flag == :set)
      raise RuntimeError("Draw flag must be set before responding to a draw")
    end
    if(response == "accept")
      @winner = "none"
    elsif(reponse == "decline")
      @draw_flag = :unset
    end
  end

  # Player forfeits the game, causing the opposing player to win
  def forfeit
    if(turn_colour == :white)
      @winner = :black
    elsif(turn_colour == :black)
      @winner = :white
    end
  end

  # Returns the winner instance variable
  def getWinner
    @winner
  end

end