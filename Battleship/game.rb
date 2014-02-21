#!/usr/bin/env ruby
Dir[File.dirname(__FILE__) + '/bin/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/renders/*.rb'].each {|file| require file }
require_relative 'settings'

class Game
  def initialize
    @render = Console.new if RENDER == 'Console'
    @game_state = MAIN_MENU
    @current_game
    @high_score = HighScore.new 'classic.hsc' if RULES == 'Classic'
    @high_score = HighScore.new 'nonclassic.hsc' if RULES == 'NonClassic'
  end

  def run
    exit = false
    while not exit
      exit = menu if @game_state == MAIN_MENU
      @game_state = @current_game.play if [SINGLE, HOT_SEAT].include? @game_state
    end
  end

  def menu
    choice = @render.draw_menu
    # if choice == SINGLE
    #   @game_state = SINGLE
    #   puts 'Battle agains Computer begins. Good Luck!'
    # end
    @game_state = choice unless choice == HIGHSCORE
    @render.print_highscore_table @high_score.users.take(20) if choice == HIGHSCORE
    @current_game = SinglePlayer.new(@render,@high_score) if choice == SINGLE
    @current_game = HotSeat.new(@render,@high_score) if choice == HOT_SEAT
    choice == EXIT
  end
end

g = Game.new
g.run