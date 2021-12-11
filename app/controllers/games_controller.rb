require_relative './fd/Final_Design_Classes.rb'

class GamesController < ApplicationController

  # Matchmaking Page
  def matchmaking()

    has_opponent = false
    if current_player.opponent_id != -1
      has_opponent = true
    else
      current_player.searching = true
      current_player.save()
    end

    if has_opponent == false
      Player.all.each do |p|
        # skip invalid possibilities
        if p.id == current_player.id || p.opponent_id != -1 || p.searching == false
          next
        end
        
        # opponent found
        current_player.colour = "white"
        current_player.searching = false
        current_player.opponent_id = p.id
        p.colour = "black"
        p.searching = false
        p.opponent_id = current_player.id
        current_player.save()
        p.save()
        has_opponent = true
        break
      end
      
      if has_opponent == false
        redirect_to game_path
        return
      end
    end

    intersections = [
      [Intersection.new("a", 1), nil, nil, Intersection.new("d", 1), nil, nil, Intersection.new("g", 1)],
      [nil, Intersection.new("b", 2), nil, Intersection.new("d", 2), nil, Intersection.new("f", 2), nil],
      [nil, nil, Intersection.new("c", 3), Intersection.new("d", 3), Intersection.new("e", 3), nil, nil],
      [Intersection.new("a", 4), Intersection.new("b", 4), Intersection.new("c", 4), nil, Intersection.new("e", 4), Intersection.new("f", 4), Intersection.new("g", 4)], 
      [nil, nil, Intersection.new("c", 5), Intersection.new("d", 5), Intersection.new("e", 5), nil, nil],
      [nil, Intersection.new("b", 6), nil, Intersection.new("d", 6), nil, Intersection.new("f", 6), nil],
      [Intersection.new("a", 7), nil, nil, Intersection.new("d", 7), nil, nil, Intersection.new("g", 7)],
    ]
    
    opponent_player = Player.find(current_player.opponent_id)
    board_obj = GameBoard.new(intersections)

    current_player_bag_obj = Bag.new()
    for i in 0..2
			current_player_bag_obj.store_piece(Piece.new(current_player.colour.to_sym()))
		end
    opponent_player_bag_obj = Bag.new()
    for i in 0..2
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

  # Game Page
  def index()

    if current_player.game != nil
      @game = gameJsonToGameObj(current_player.game)
    end
    if params["commit"] == "Place"
      place_piece(params)
    elsif params["commit"] == "Move"
      move_piece(params)
    elsif params["commit"] == "Capture"
      capture_piece(params)
    end
    
  end

  private
  def place_piece(params)

    x = params['x'].ord() - 97
    y = params['y'].to_i() - 1

    coordinate = params['x'] + params['y']
    valid_intersections = ['a7', 'd7', 'g7', 'b6', 'd6', 'f6', 'c5', 'd5', 'e5', 'a4', 'b4', 'c4', 'e4', 'f4', 'g4', 'c3', 'd3', 'e3', 'b2', 'd2', 'f2', 'a1', 'd1', 'g1']
    if @game.turn_colour != current_player.colour.to_sym()
      flash.alert = "Please wait your turn. Opponent player is taking turn."
      redirect_to game_path
      return
    end
    if !valid_intersections.include?(coordinate)
      flash.alert = "Please provide a valid intersection to proceed with piece placement."
      redirect_to game_path
      return
    elsif !@game.player1.board.is_empty_intersection(x, y)
      puts(x, y)
      flash.alert = "The intersection selected is occupied. Please select another intersection."
      redirect_to game_path
      return
    end

    player = getCurrentPlayerObj(@game, current_player)
    player.place_piece_on_board(x, y, player.bag.select_piece)
    puts(current_player.mill_found)
    current_player.mill_found = player.board.is_piece_in_mill(current_player.colour.to_sym(), x, y)
    puts(current_player.mill_found)
    if current_player.mill_found == false
      @game.alternate_turn()
    end

    gameJson = @game.to_json()
    current_player.game = gameJson
    current_player.save()

    opponent_player = Player.find(current_player.opponent_id)
    opponent_player.game = gameJson
    opponent_player.save()

    redirect_to game_path
    
  end
  
  def move_piece(params)

    from_x = params['from_x'].ord() - 97
    from_y = params['from_y'].to_i() - 1
    to_x = params['to_x'].ord() - 97
    to_y = params['to_y'].to_i() - 1

    from_coordinate = params['from_x'] + params['from_y']
    to_coordinate = params['to_x'] + params['to_y']
    valid_intersections = ['a7', 'd7', 'g7', 'b6', 'd6', 'f6', 'c5', 'd5', 'e5', 'a4', 'b4', 'c4', 'e4', 'f4', 'g4', 'c3', 'd3', 'e3', 'b2', 'd2', 'f2', 'a1', 'd1', 'g1']
    if @game.turn_colour != current_player.colour.to_sym()
      flash.alert = "Please wait your turn. Opponent player is taking turn."
      redirect_to game_path
      return
    end
    if !valid_intersections.include?(from_coordinate) 
      flash.alert = "Please provide a valid intersection to move the piece from."
      redirect_to game_path
      return
    elsif !valid_intersections.include?(to_coordinate)
      flash.alert = "Please provide a valid intersection to move the piece to."
      redirect_to game_path
      return
    elsif @game.player1.board.is_empty_intersection(from_x, from_y)
      flash.alert = "The intersection selected to move piece from is occupied. Please select another intersection."
      redirect_to game_path
      return
    elsif !@game.player1.board.is_empty_intersection(to_x, to_y)
      flash.alert = "The intersection selected to move piece to is occupied. Please select another intersection."
      redirect_to game_path
      return
    elsif !@game.player1.board.check_occupant_colour_matches_turn(@game.turn_colour, from_x, from_y)
      flash.alert = "The intersection selected to move a piece from has a piece that does not belong to you. Please select another intersection."
      redirect_to game_path
      return
    elsif @game.player1.board.count_pieces_on_board(current_player.colour.to_sym()) > 3 && !isMoveAdjacent(from_x, from_y, to_x, to_y)
      flash.alert = "The intersection selected to move a piece to is not adjacent to the intersection selected to move a piece from. Please select another intersection."
      redirect_to game_path
      return
    end

    player = getCurrentPlayerObj(@game, current_player)
    player.board.place_and_remove_piece(to_x, to_y, from_x, from_y)
    current_player.mill_found = player.board.is_piece_in_mill(current_player.colour.to_sym(), to_x, to_y)
    if current_player.mill_found == false
      @game.alternate_turn()
    end

    gameJson = @game.to_json()
    current_player.game = gameJson
    current_player.save()

    opponent_player = Player.find(current_player.opponent_id)
    opponent_player.game = gameJson
    opponent_player.save()

    redirect_to game_path

  end

  def capture_piece(params)

    x = params['x'].ord() - 97
    y = params['y'].to_i() - 1
    oppositeColour = @game.turn_colour.to_s == :white.to_s ? :black : :white

    if @game.turn_colour != current_player.colour.to_sym()
      flash.alert = "Please wait your turn. Opponent player is taking turn."
      redirect_to game_path
      return
    end
    begin
      if !@game.player1.board.check_occupant_colour_matches_turn(oppositeColour, x, y)
        flash.alert = "The intersection selected to capture a piece does not have a piece that belongs to the opponent. Please select another intersection."
        redirect_to game_path
        return
      end
    rescue
      flash.alert = "Please provide a valid intersection to capture a piece."
      redirect_to game_path
      return
    end

    player = getCurrentPlayerObj(@game, current_player)
    player.board.remove_piece(x, y)
    current_player.mill_found = false
    @game.alternate_turn()
    
    gameJson = @game.to_json()
    current_player.game = gameJson
    current_player.save()

    opponent_player = Player.find(current_player.opponent_id)
    opponent_player.game = gameJson
    opponent_player.save()

    redirect_to game_path

  end

end
