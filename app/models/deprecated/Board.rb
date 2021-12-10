class Board < ApplicationRecord

  belongs_to :game, -> { joins(:id) }

end
