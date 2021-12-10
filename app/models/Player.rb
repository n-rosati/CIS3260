class Player < ApplicationRecord

  # has_one :game, :foreign_key => 'id'
  # has_one :bag, -> { joins(:id) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # before_create :initialize_player
  # def initialize_player()
  # end
  
end
