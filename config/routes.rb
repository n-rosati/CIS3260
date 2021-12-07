Rails.application.routes.draw do

  root 'sessions#check_session'

  get 'login', to: 'sessions#check_session'
  get 'home', to: 'player#player_home'
  get 'logout', to: 'player#logout_player'

  post 'findmatch', to: 'game#find_match'
  post 'newgame', to: ' game#start_game'
  post 'playagain', to: 'game#play_again'
  post 'signup', to: 'player#create_account'
  post 'loginplayer', to: 'sessions#create_session'

  put 'move', to: 'player#move_piece'
  put 'capture', to: 'player#capture_piece'
  put 'place', to: 'player#place_piece'
  put 'forfeit', to: 'game#forfeit'
  put 'draw', to: 'game#propose_draw'
  put 'drawrespond', to: 'game#respond_draw'

  delete 'delete', to: 'player#delete_player'

end
