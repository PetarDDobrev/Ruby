#!/usr/bin/env ruby
Dir[File.dirname(__FILE__) + '/bin/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/renders/*.rb'].each {|file| require file }
require_relative 'settings'


##the main class of the game
#Game class is used for creating a battleship game
class Game
  ##creates a game based on the settings.
  #the settings can be seen/changed in settings.rb
  #@render is the render system
  #@games_state is the state of the game, chech constants.rb for more info
  #@current_game can be a SinglePlayer or HotSeat class
  #@high_score is the highscore system. There are different files for
  #different rules
  def initialize
    @render = Console.new if RENDER == 'Console'
    @game_state = MAIN_MENU
    @current_game
    @high_score = HighScore.new 'classic.hsc' if RULES == 'Classic'
    @high_score = HighScore.new 'nonclassic.hsc' if RULES == 'NonClassic'
  end

  ##run is the game loop
  def run
    exit = false
    while not exit
      exit = menu if @game_state == MAIN_MENU
      @game_state = @current_game.play if [SINGLE, HOT_SEAT].include? @game_state
    end
  end

  ##menu is the main menu of the game
  #from here player can choose 4 options
  #1.Single player game
  #2.Hot seat game
  #3.see High scores
  #4.exit the game
  def menu
    choice = @render.draw_menu
    @game_state = choice unless choice == HIGHSCORE
    @render.print_highscore_table @high_score.users.take(20) if choice == HIGHSCORE
    @current_game = SinglePlayer.new(@render,@high_score) if choice == SINGLE
    @current_game = HotSeat.new(@render,@high_score) if choice == HOT_SEAT
    choice == EXIT
  end
end

game = Game.new
game.run