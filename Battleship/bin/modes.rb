Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/../renders/*.rb'].each {|file| require file }

##class Mode is parent class of SinglePlayer and HotSeat
class Mode
  ##initilizes(sets) a given player
  #signs the player in teh hiighscore system
  #sets player board(puting ships on the board)
  def initialize_player(player)
    sign_in(player)
    @render.announce_player player.user.name
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

  ##sign in/sign up a given player in the high score system data base
  #if the player does not finish a game he is not saved in the data base
  def sign_in(player)
    correct_user_info = false
    while not correct_user_info
      username = @render.username
      exists, player.user = @high_score.user_exists? username
      player.user.name = username unless exists
      @high_score.add_user player.user unless exists
      password = @render.password player.user, exists
      correct_user_info = @high_score.correct_password? player.user,exists, password
    end
    @render.print_user(player.user)
  end

  ##checks if the given player lost the game
  #Classic rules: all parts of the ship must be hit
  #NonClassic rules: each ship must be hit at least once
  def lose?(player)
    ships_left = player.ships.reject{|s| s.dead?} if RULES == 'Classic'
    ships_left = player.ships.reject{|s| s.hit?} if RULES == 'NonClassic'
    return true if ships_left.length == 0
    false
  end

  ##player_one 'shoots' at player_two
  def player_shoot(player_one, player_two)
    ships_left = player_one.ships.reject{|s| s.dead?}.length
    puts "\n#{player_one.user.name}'s turn to shoot!"
    puts "You have #{ships_left} ships left"
    @render.draw_board player_one.enemy_board
    cell = @render.select_cell player_one.my_board
    result = player_one.shoot player_two, cell
    puts 'You hit enemy ship!' if result
    if lose?(@player_two) then
      puts 'You Win!'
      player_one.user.add_points(ships_left)
      player_one.user.win
      player_two.user.lose
      @high_score.save
      return true
    end
    false
  end
end

##SinglePlayer class is used for creating a battle against AI
class SinglePlayer < Mode
  ##Creates a  single player game
  #render is the currently selected render system
  #high_score is the high score system
  #@turn is following the numbers of turns of the game
  #player_one is teh human player
  #player_two is teh AI
  def initialize(render,high_score)
    @turn = 0
    @player_one = Player.new
    @player_two = AI.new
    @render = render
    @high_score = high_score
    initialize_ai @player_two
    @render.ai_ready
    initialize_player @player_one
    @render.player_ready @player_one.user.name
  end

  ##play contains the main gameplay logic
  def play
    @turn = @turn + 1
    @render.current_turn(@turn)
    game_state = SINGLE
    puts 'AI shooting!'
    
    result = @player_two.shoot @player_one
    puts 'AI got hit one of your ships' if result
    @render.draw_board @player_two.enemy_board if AI_ENEMY_BOARD
    if lose?(@player_one) then
      puts 'AI Wins!'
      @player_one.user.lose
      @high_score.save
      game_state = MAIN_MENU
    end    
    game_state = MAIN_MENU if player_shoot @player_one, @player_two 
    game_state
  end

  #initializes the AI- it generetes AI my_board
  def initialize_ai(player)
    @render.announce_ai
    player.generate_board
  end
end

##HotSeat is a class for creatign a game for two human players
class HotSeat < Mode
  ##Creates a  hot seat game
  #render is the currently selected render system
  #high_score is the high score system
  #@turn is following the numbers of turns of the game
  #player_one and player_two are human players
  def initialize(render,high_score)
    @turn = 0
    @player_one = Player.new
    @player_two = Player.new
    @render = render
    @high_score = high_score
    initialize_player @player_one
    @render.next_player
    @render.player_ready @player_one.user.name
    initialize_player @player_two
    @render.next_player
    @render.player_ready @player_two.user.name
  end

  ##play contains the main gameplay logic
  def play
    game_state = SINGLE
    game_state = MAIN_MENU if player_shoot @player_one, @player_two
    game_state = MAIN_MENU if player_shoot @player_two, @player_one
    game_state
  end
end