class Game < ApplicationRecord

  belongs_to :player
  # has_one :board, -> { joins(:id) }

end
