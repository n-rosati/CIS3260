class Player < ApplicationRecord
  has_secure_password
  has_one :game, :bag
end
