Rails.application.routes.draw do

  # devise_for :players
  resources :players, only: :edit

  # get 'games', to: 'games#new', :as => 'default_game'
  # get 'games/new', to: 'games#new', :as => 'new_game'
  get 'games/matchmaking' , to: 'games#matchmaking', :as => 'matchmaking'
  get 'games/index', to: 'games#index', :as => 'game'

  unauthenticated :player do
    devise_scope :player do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  authenticated :player do
    root to: 'home#index', as: :authenticated_root
  end

  devise_for :player do
    get 'player/sign_out', to: 'devise/sessions#destroy', :as => 'sign_out_player_session'
    get 'player/edit', to: 'devise/registrations#edit', :as => 'edit_player_registration'    
    put 'player', to: 'devise/registrations#update', :as => 'player_registration'            
  end

  # root 'sessions#check_session'
  # get 'login', to: 'sessions#check_session'
  # get 'home', to: 'player#player_home'
  # get 'logout', to: 'player#logout_player'
  # post 'findmatch', to: 'game#find_match'
  # post 'newgame', to: ' game#start_game'
  # post 'playagain', to: 'game#play_again'
  # post 'signup', to: 'player#create_account'
  # post 'loginplayer', to: 'sessions#create_session'
  # put 'move', to: 'player#move_piece'
  # put 'capture', to: 'player#capture_piece'
  # put 'place', to: 'player#place_piece'
  # put 'forfeit', to: 'game#forfeit'
  # put 'draw', to: 'game#propose_draw'
  # put 'drawrespond', to: 'game#respond_draw'
  # delete 'delete', to: 'player#delete_player'
  # get 'items/index', to: 'items#index', :as => 'item'
  # get 'items/add_coin', to: 'items#add_coin', :as => 'add_coin'
  # get 'items/add_die', to: 'items#add_die', :as => 'add_die'
  # get 'games', to: 'games#new', :as => 'default_game'
  # get 'games/new', to: 'games#new', :as => 'new_game'
  # get 'games/index', to: 'games#index', :as => 'game_start'
  # get 'games/results', to: 'games#results', :as => 'game_end'
  # get 'games/load_coins', to: 'games#load_coins', :as => 'load_coins'
  # get 'games/load_dice', to: 'games#load_dice', :as => 'load_dice'
  # get 'games/empty_cup', to: 'games#empty_cup', :as => 'empty_cup'
  # get 'games/user_throw', to: 'games#user_throw', :as => 'user_throw'
  # get 'games/select_throw', to: 'games#select_throw', :as => 'select_throw'

end
 