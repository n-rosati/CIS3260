class ApplicationController < ActionController::Base

    helper_method :gameJsonToGameObj, :intersectionsToString, :intersectionToString

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
                curr_row << Intersection.new(i['x'], i['y'], Piece.new(i['occupant']['colour_sym'].to_sym()))
              end
            end
          end
          intersections << curr_row
        end
        board_obj = GameBoard.new(intersections)

        player1_bag_obj = Bag.new()
        player2_bag_obj = Bag.new()
        parsedPlayer1['bag']['pieces'].each do |piece|
          player1_bag_obj.store_piece(Piece.new(piece['colour_sym'].to_sym()))
        end
        parsedPlayer2['bag']['pieces'].each do |piece|
          player2_bag_obj.store_piece(Piece.new(piece['colour_sym'].to_sym()))
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
        intersections.each do |i|
          if i != nil
            intersection_strings << intersectionToString(i)
          end
        end
        return intersection_strings
      end

      def intersectionToString(intersection)
        if intersection.occupant == nil
          return "⬜"
        elsif intersection.occupant.colour_sym == :white
          return "⚪"
        elsif intersection.occupant.colour_sym == :black
          return "⚫"
        end
      end

      def x_to_int(x)

      end

end
