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
    @battle_begin = false
  end

  def run
    exit = false
    while not exit
      exit = menu if @game_state == MAIN_MENU
      single_player if @game_state == SINGLE
      hot_seat if @game_state == HOT_SEAT
    end
  end

  def single_player
    initialize_sp if @battle_begin
    puts 'AI shooting!'
    result = @player_two.shoot @player_one
    puts 'AI got hit one of your ships' if result
    if loose?(@player_one) then
      puts 'AI Wins!'
      @game_state = MAIN_MENU
      @battle_begin = false
    end
    @render.draw_board @player_two.my_board 
    @render.draw_board @player_one.enemy_board
    puts 'Your turn to shoot!'
    cell = @render.select_cell @player_one.my_board
    puts 'Cell seleceted: ', cell
    result = @player_one.shoot @player_two, cell
    puts 'You hit enemy ship!' if result
    if loose?(@player_two) then
      puts 'You Win!'
      @game_state = MAIN_MENU
      @battle_begin = false
    end
  end
  
  def initialize_sp
    @player_one = Player.new 1
    @player_two = AI.new 2
    initialize_ai @player_two
    puts 'AI READY!' 
    initialize_player @player_one
    puts 'player ready'
    @battle_begin = false
  end

  def initialize_player(player)
    @render.announce_player player.id
    player.generate_board
    while not player.ready?
      @render.draw_board player.my_board
      ship_size = MAX_SHIP_SIZE - @render.select_ship(player.ships_unset)
      ship = Ship.new(ship_size)
      correct_cordinates = false
      while not correct_cordinates
        p cordinates = @render.select_cordinates(ship_size)
        if ship.set_position(cordinates[0], cordinates[1])
          correct_cordinates = true if player.my_board.put_ship ship
          player.ship_ready(ship)
        end
        @render.incorrect_cordinates
      end
    end
    @render.draw_board player.my_board
  end

  def initialize_ai(player)
    @render.announce_ai
    player.generate_board
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
    @battle_begin = true if choice != EXIT
    choice == EXIT
  end

  def loose?(player)
    ships_left = player.ships.reject{|s| s.dead?}
    return true if ships_left.length == 0
    false
  end
end

g = Game.new
g.run