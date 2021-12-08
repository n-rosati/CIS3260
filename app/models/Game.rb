class Game < ApplicationRecord
  belongs_to :player
  has_one :board
end
