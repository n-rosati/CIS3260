class GamePlayer
	# Creates a new Player
	# @param [String] name The name of the player
	# @param [Symbol] colour The colour of the Player, `:white` or `:black`
	def initialize(name, colour, board, bag)
		if !name.is_a?(String)
			raise TypeError("First parameter must be a string")
		elsif colour != :white && colour != :black
			raise TypeError("Second parameter must be :white or :black")
		end

		@name = name
		@colour = colour
		@board = board
		@bag = bag
	end

	def name
		@name
	end
	
	def colour
		@colour
	end
	
	def board
		@board
	end

	def bag
		@bag
	end

	# Places a Piece on an Intersection
	# @param [Integer] x Intersection x coordinate
	# @param [Integer] y Intersection y coordinate
	# @param [Piece] piece Piece to place at intersection (x,y)
	def place_piece_on_board(x, y, piece)
		# puts("place_piece_on_board(#{x}, #{y}, { \"colour\": #{piece.colour()} })")
		if !x.is_a?(Integer)
			raise TypeError("First parameter must be an integer")
		elsif !y.is_a?(Integer)
			raise TypeError("Second parameter must be an integer")
		elsif !piece.instance_of?(Piece)
			raise TypeError("Third parameter must be instance of Piece")
		end

		@board.place_piece(x, y, piece)
	end
	
	# Move a piece to (x, y) from (piece_x, piece_y)
	# @param [Integer] x Destination Intersection x coordinate
	# @param [Integer] y Destination Intersection y coordinate
	# @param [Integer] piece_x Source Intersection x coordinate
	# @param [Integer] piece_y Source Intersection y coordinate
	def move_piece(x, y, piece_x, piece_y)
		if !x.is_a?(Integer)
			raise TypeError("First parameter must be an integer")
		elsif !y.is_a?(Integer)
			raise TypeError("Second parameter must be an integer")
		elsif !piece_x.is_a?(Integer)
			raise TypeError("Third parameter must be an integer")
		elsif !piece_y.is_a?(Integer)
			raise TypeError("Fourth parameter must be an integer")
		end

		@board.place_and_remove_piece(x, y, piece_x, piece_y)
	end

	# Removes the Piece at (x, y) from the board
	# @param [Integer] x
	# @param [Integer] y
	def capture_piece(x, y)
		if !x.is_a?(Integer)
			raise TypeError("First parameter must be an integer")
		elsif !y.is_a?(Integer)
			raise TypeError("Second parameter must be an integer")
		end

		@board.remove_piece(x, y)
	end

	# @return [Symbol] Returns the colour of the player, `:white` or `:black`
	def get_colour
		@colour
	end

	# @return [Boolean] The empty status of the Player's bag
	def is_bag_empty
		@bag.is_empty
	end
end
