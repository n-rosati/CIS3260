class Intersection
	# @param [String] x Intersection x coordinate
	# @param [Integer] y Intersection y coordinate
	# @param [Piece] occupant Optional. Piece that is in the intersection.
	def initialize(x, y, occupant = nil)
		if !x.is_a?(String)
			raise TypeError("First parameter must be a string")
		elsif !y.is_a?(Integer)
			raise TypeError("Second parameter must be a integer")
		elsif !!occupant && !occupant.instance_of?(Piece)
			raise TypeError("Third parameter must be an instance of Piece")
		end

		@x = x
		@y = y
		@occupant = occupant
	end

	def x
		@x
	end

	def y
		@y
	end

	def occupant
		@occupant
	end

	# Removes and returns the Piece occupying the intersection. If none, returns nil.
	# @return [Piece, nil] Piece occupying the intersection. Nil if no there is no piece.
	def take_occupant
		occupant = @occupant
		@occupant = nil

		occupant
	end

	# @return [Boolean] True if the intersection is occupied, else false
	def is_occupied
		!!@occupant
	end

	# @return [Integer] The x value as an integer
	def get_x_as_integer
		@x.ord() - 97
	end

	# Clears the intersection occupant
	def clear
		@occupant = nil
	end

	# Places a piece in the intersection
	# @param [Piece] piece Piece to set in the intersection
	def place_occupant(piece)
		unless piece.instance_of?(Piece)
			throw TypeError("Parameter must be an instance of Piece")
		end

		@occupant = piece
	end

	# @return [Symbol, nil] Returns the colour of the occupant, nil if no occupant in intersection
	def get_occupant_colour
		if !!@occupant
			@occupant.colour.to_s()
		else
			"nil"
		end
	end
end
