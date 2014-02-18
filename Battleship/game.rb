#!/usr/bin/env ruby
Dir[File.dirname(__FILE__) + '/bin/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/renders/*.rb'].each {|file| require file }
require_relative 'settings'

class Game
  def initialize
    @render = Console.new if RENDER == 'Console'
    @game_state = MAIN_MENU
    @current_game
  end

  def run
    exit = false
    while not exit
      exit = menu if @game_state == MAIN_MENU
      @game_state = @current_game.play if [SINGLE, HOT_SEAT].include? @game_state
    end
  end

  def hot_seat
    if not @player_one.ready?
      @player_one.generate_board
    end
    @render.draw_board(@player_one.my_board)

    if not @player_two.ready?
      @player_two.generate_board
    end
    @render.draw_board(@player_two.my_board)
  end 

  def menu
    choice = @render.draw_menu
    # if choice == SINGLE
    #   @game_state = SINGLE
    #   puts 'Battle agains Computer begins. Good Luck!'
    # end
    @game_state = choice
    @current_game = SinglePlayer.new(@render) if choice == SINGLE
    @current_game = HotSeat.new(@render) if choice == HOT_SEAT
    choice == EXIT
  end
end

g = Game.new
g.run