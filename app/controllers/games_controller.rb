require_relative './fd/Final_Design_Classes.rb'

class GamesController < ApplicationController

  def index()
    @game = gameJsonToGameObj(current_player.game)
    if params["commit"] == "Place"
      place_piece(params)
    end
  end

  def find_match()

    opponent_found = false
    if current_player.opponent_id == -1
      Player.all.each do |p|
        if current_player.id != p.id && p.opponent_id == -1
          opponent_found = true
          current_player.opponent_id = p.id
          p.opponent_id = current_player.id
          current_player.save()
          p.save()
        end
      end
    else
      opponent_found = true
    end
    if opponent_found == false
      redirect_to find_match_path
      return
    end

    intersections = [
      [Intersection.new("a", 7), nil, nil, Intersection.new("d", 7), nil, nil, Intersection.new("g", 7)],
      [nil, Intersection.new("b", 6), nil, Intersection.new("d", 6), nil, Intersection.new("f", 6)], 
      [nil, nil, Intersection.new("c", 5), Intersection.new("d", 5), Intersection.new("e", 5), nil, nil],
      [Intersection.new("a", 4), Intersection.new("b", 4), Intersection.new("c", 4), nil, Intersection.new("e", 4), Intersection.new("f", 4), Intersection.new("g", 4)], 
      [nil, nil, Intersection.new("c", 3), Intersection.new("d", 3), Intersection.new("e", 3), nil, nil],
      [nil, Intersection.new("b", 2), nil, Intersection.new("d", 2), nil, Intersection.new("f", 2), nil], 
      [Intersection.new("a", 1), nil, nil, Intersection.new("d", 1), nil, nil, Intersection.new("g", 1)]
    ]
    
    opponent_player = Player.find(current_player.opponent_id)
    opponent_player.colour = "black"
    board_obj = GameBoard.new(intersections)

    current_player_bag_obj = Bag.new()
    for i in 0..8
			current_player_bag_obj.store_piece(Piece.new(current_player.colour.to_sym()))
		end
    opponent_player_bag_obj = Bag.new()
    for i in 0..8
			opponent_player_bag_obj.store_piece(Piece.new(opponent_player.colour.to_sym()))
		end
    
    curr_player_obj = GamePlayer.new(current_player.email, current_player.colour.to_sym(), board_obj, current_player_bag_obj)
    opponent_player_obj = GamePlayer.new(opponent_player.email, opponent_player.colour.to_sym(), board_obj, opponent_player_bag_obj)
    game_obj = Game.new(curr_player_obj, opponent_player_obj, board_obj, :place, :white)

    current_player.game = game_obj.to_json()
    current_player.save()
    opponent_player.game = game_obj.to_json()
    opponent_player.save()

    redirect_to game_path

  end

  def place_piece(params)

    x = params['x'].to_i() + 1
    y = params['y'].to_i()


    curr_player_colour = current_player.colour.to_sym()
    if @game.player1.colour == curr_player_colour

      puts("Class: ")
      puts(@game.player1.bag.select_piece.class)
      puts()
      if @game.turn_colour == :white
        @game.player1.place_piece_on_board(x, y, @game.player1.bag.select_piece)
        @game.alternate_turn()
      elsif @game.turn_colour == :black
        @game.player1.place_piece_on_board(x, y, @game.player1.bag.select_piece)
        @game.alternate_turn()
      end

    elsif @game.player2.colour == curr_player_colour

      if @game.turn_colour == :white
        @game.player2.place_piece_on_board(x, y, @game.player2.bag.select_piece)
        @game.alternate_turn()
      elsif @game.turn_colour == :black
        @game.player2.place_piece_on_board(x, y, @game.player2.bag.select_piece)
        @game.alternate_turn()
      end
      
    end

    current_player.game = @game
    current_player.save()

    redirect_to game_path
    
  end
  
  def move_piece(params)

    from_x = params['from_x']
    from_y = params['from_y'].to_i()
    to_x = params['to_x']
    to_y = params['to_y'].to_i()

    curr_player_colour = current_player.colour.to_sym()
    if @game.player1.colour == curr_player_colour

      if @game.turn_colour == :white && @game.player1.board.check_occupant_colour_matches_turn(from_x, from_y, :white)
        @game.player1.board.place_and_remove_piece(to_x, to_y, from_x, from_y)
        @game.alternate_turn()
      elsif @game.turn_colour == :black && @game.player1.board.check_occupant_colour_matches_turn(from_x, from_y, :black)
        @game.player1.board.place_and_remove_piece(to_x, to_y, from_x, from_y)
        @game.alternate_turn()
      end

    elsif @game.player2.colour == curr_player_colour

      if @game.turn_colour == :white && @game.player2.board.check_occupant_colour_matches_turn(from_x, from_y, :white)
        @game.player2.board.place_and_remove_piece(to_x, to_y, from_x, from_y)
        @game.alternate_turn()
      elsif @game.turn_colour == :black && @game.player2.board.check_occupant_colour_matches_turn(from_x, from_y, :black)
        @game.player2.board.place_and_remove_piece(to_x, to_y, from_x, from_y)
        @game.alternate_turn()
      end
      
    end

    current_player.game = @game
    current_player.save()

    redirect_to game_path

  end

end
