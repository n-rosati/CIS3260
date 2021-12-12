
class ApplicationController < ActionController::Base

    helper_method :gameJsonToGameObj, :intersectionsToString, :intersectionToString, :getPlayerObj, :isMoveAdjacent, :abs

    private

      def gameJsonToGameObj(gameJson)
        parsed = JSON.parse(gameJson)
        parsedPlayer1 = parsed['player1']
        parsedPlayer2 = parsed['player2']
        parsedBoard = parsedPlayer1['board']
        parsedIntersections = parsedBoard['intersections']
        intersections = []
        parsedIntersections.each do |pi|
          curr_row = []
          pi.each do |i|
            if i == nil
              curr_row << nil
            else
              if i['occupant'] == nil
                curr_row << Intersection.new(i['x'], i['y'], nil)
              else
                curr_row << Intersection.new(i['x'], i['y'], Piece.new(i['occupant']['colour'].to_sym()))
              end
            end
          end
          intersections << curr_row
        end
        board_obj = GameBoard.new(intersections)

        player1_bag_obj = Bag.new()
        player2_bag_obj = Bag.new()
        parsedPlayer1['bag']['pieces'].each do |piece|
          player1_bag_obj.store_piece(Piece.new(piece['colour'].to_sym()))
        end
        parsedPlayer2['bag']['pieces'].each do |piece|
          player2_bag_obj.store_piece(Piece.new(piece['colour'].to_sym()))
        end

        return Game.new(
          GamePlayer.new(parsedPlayer1['name'], parsedPlayer1['colour'].to_sym(), board_obj, player1_bag_obj),
          GamePlayer.new(parsedPlayer2['name'], parsedPlayer2['colour'].to_sym(), board_obj, player2_bag_obj),
          board_obj,
          parsed['phase'].to_sym(), 
          parsed['turn_colour'].to_sym()
        )
      end

      def intersectionsToString(intersections)
        intersection_strings = []
        curr_row = 0
        intersections.each do |i|
          # puts("Row #{curr_row}")
          curr_row += 1
          if i != nil
            intersection_strings << intersectionToString(i)
          end
        end
        return intersection_strings
      end

      def intersectionToString(intersection)
        # puts("Intersection at (#{intersection.x}, #{intersection.y})")
        if intersection.occupant == nil
          return "⬜"
        elsif intersection.occupant.colour == :white
          return "⚪"
        elsif intersection.occupant.colour == :black
          return "⚫"
        end
      end

      def getPlayerObj(game_obj, player_db_model)
        if game_obj.player1.name() == player_db_model.email
          return game_obj.player1
        elsif game_obj.player2.name() == player_db_model.email
          return game_obj.player2
        end
      end

      def isMoveAdjacent(from_x, from_y, to_x, to_y)

        centre = 3
        from_centre_x = abs(from_x - centre)
        from_centre_y = abs(from_y - centre)
        can_move_x = from_centre_y
        can_move_y = from_centre_x
        if can_move_x == 0
          can_move_x = 1
        end
        if can_move_y == 0
          can_move_y = 1
        end

        diff_x = abs(from_x - to_x)
        diff_y = abs(from_y - to_y)    
    
        return ((diff_y == can_move_y &&  from_x == to_x) || (diff_x == can_move_x && from_y == to_y))
    
      end

      def abs(x)
        
        if (x < 0)
          return x * -1
        else
          return x
        end

      end

end
