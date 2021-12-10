class Piece
	# Creates a new Piece
	# @param [Symbol] colour The colour of the Piece to create. Can be either `:white` or `:black`
	def initialize(colour_sym)
		if colour_sym != :white && colour_sym != :black
			raise TypeError("Parameter must be :white or :black")
		end

		@colour_sym = colour_sym
	end

	# @return [Symbol] The colour of the Piece
	def colour_sym
		@colour_sym
	end
end
