class Bag < ApplicationRecord

  belongs_to :player, -> { joins(:id) }
  has_many :piece, -> { joins(:id) }

end

