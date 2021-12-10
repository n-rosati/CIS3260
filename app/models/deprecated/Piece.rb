class Piece < ApplicationRecord

  belongs_to :intersection, -> { joins(:id) }
  belongs_to :bag, -> { joins(:id) }

end
