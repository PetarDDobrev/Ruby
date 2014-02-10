#!/usr/bin/env ruby
Dir[File.dirname(__FILE__) + '/bin/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/renders/*.rb'].each {|file| require file }
require_relative 'settings'

class Game
  def initialize
    @player_one = Player.new(1)
    @player_two = Player.new(2)
    @render = Console.new if RENDER == 'Console'
    @game_state = MAIN_MENU
  end

  def run
    exit = false
    while not exit
      exit = menu if @game_state == MAIN_MENU
      single_player if @game_state == SINGLE
    end
  end

  def single_player
    if not @player_one.ready?
      @render.draw_board(@player_one.my_board.board)
      ship_size = MAX_SHIP_SIZE - @render.select_ship(@player_one.ships_unset)
      ship = Ship.new(ship_size)
      correct_cordinates = false
      while not correct_cordinates
        p cordinates = @render.select_cordinates(ship_size)
        p 'cord again' 
        if ship.set_position(cordinates[0], cordinates[1])
          correct_cordinates = true if @player_one.my_board.put_ship ship
          @player_one.ship_ready(ship)
        end
        #error: incorrect cordinates
      end
    end

  end

  def menu
    choice = @render.draw_menu
    if choice == SINGLE
      @game_state = SINGLE
      puts 'Battle agains Computer begins. Good Luck!'
    end
    choice == EXIT
  end
end

g = Game.new
g.run