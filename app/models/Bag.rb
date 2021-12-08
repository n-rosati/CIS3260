class Bag < ApplicationRecord
  belongs_to :player
  has_many :piece
end

