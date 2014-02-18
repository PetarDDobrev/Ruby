Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/../renders/*.rb'].each {|file| require file }

class Mode
  def initialize_player(player)
    @render.announce_player player.id
    player.generate_board if BOARDS_GENERATED
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

  def loose?(player)
    ships_left = player.ships.reject{|s| s.dead?} if RULES == 'Classic'
    ships_left = player.ships.reject{|s| s.hit?} if RULES == 'NonClassic'
    return true if ships_left.length == 0
    false
  end

  def player_shoot(player_one, player_two)
    @render.draw_board player_two.my_board 
    #@render.draw_board @player_one.enemy_board
    ships_left = player_one.ships.reject{|s| s.dead?}.length
    puts "Player #{player_one.id} turn to shoot!"
    puts "You have #{ships_left} ships left"
    cell = @render.select_cell player_one.my_board
    result = player_one.shoot player_two, cell
    puts 'You hit enemy ship!' if result
    if loose?(@player_two) then
      puts 'You Win!'
      return true
    end
    false
  end

end

class SinglePlayer < Mode
  def initialize(render)
    @player_one = Player.new 1
    @player_two = AI.new 2
    @render = render
    initialize_ai @player_two
    @render.ai_ready
    initialize_player @player_one
    @render.player_ready @player_one.id
  end

  def play
    game_state = SINGLE
    puts 'AI shooting!'
    
    result = @player_two.shoot @player_one
    puts 'AI got hit one of your ships' if result
    if loose?(@player_one) then
      puts 'AI Wins!'
      game_state = MAIN_MENU
    end    
    game_state = MAIN_MENU if player_shoot @player_one, @player_two 
    game_state
  end

  def initialize_ai(player)
    @render.announce_ai
    player.generate_board
  end
end

class HotSeat < Mode
  def initialize(render)
    @player_one = Player.new 1
    @player_two = Player.new 2
    @render = render
    initialize_player @player_one
    @render.player_ready @player_one.id
    initialize_player @player_two
    @render.player_ready @player_two.id
  end

  def play
    game_state = SINGLE    
    game_state = MAIN_MENU if player_shoot @player_one, @player_two 
    game_state = MAIN_MENU if player_shoot @player_two, @player_one 
    game_state
  end
end