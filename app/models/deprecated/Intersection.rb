class Intersection < ApplicationRecord

  has_one :piece, -> { joins(:id) }
  
end
