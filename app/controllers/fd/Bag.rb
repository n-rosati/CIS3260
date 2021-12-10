class Bag
	# Creates a new, empty Bag
	def initialize
		@pieces = []
	end

	def length
		@pieces.length
	end

	# Removes a Piece from the Bag
	# @return [Piece, nil] Returns a Piece from the bag, nil if bag is empty
	def select_piece
		@pieces.pop
	end

	# Puts a Piece in the Bag
	# @param [Piece] piece The Piece to put in the Bad
	def store_piece(piece)
		unless piece.instance_of?(Piece)
			raise TypeError("Parameter must be instance of Piece")
		end

		@pieces.push(piece)
	end

	# @return [Boolean] Empty state of the Bag
	def is_empty
		@pieces.empty?
	end

	# Empties the Bag of its contents
	def empty_bag
		@pieces.clear
	end
end
