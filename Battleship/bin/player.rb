require_relative 'constants'
require_relative 'ship'
require_relative 'board'
require_relative 'highscore'


class Player
  attr_accessor :user, :my_board, :enemy_board, :ships_unset, :ships
  ##creates a player object
  #@user is used to save teh player game statistics, its password protected
  #@my_board is the board on which the player sets/puts his ships
  #@enemy_board is the board on which the player thargets enemy ships
  #@ships is and array of all player's ship
  #@ships_unset is hash that holds information about how many
  #ships of each type player have not set yet
  def initialize
    @user = User.new
    @my_board = Board.new
    @enemy_board = Board.new
    @ships = []
    @ships_unset = Hash[SHIP_SET.collect { |k| [k, SHIP_SET.index(k) + 1]} ]
  end

  ##checks if all player's ships are set
  def ready?
    @ships_unset.values.reduce(:+) == 0
  end

  ##adds the ship to players ships and removes it from the unset
  def ship_ready(ship)
    ship_type = SHIP_SET.reverse[ship.size-1]
    @ships.push ship
    @ships_unset[ship_type] = @ships_unset[ship_type] - 1
  end

  #a cell is given and if a ships is found on that cell it is "hit"
  def hit_ship(cell)
    @ships.each do |ship|
      ship.hit cell
    end
  end

  ##generates a randomized board
  #used for AI
  def generate_board
    ships_left_size = [4,3,3,2,2,2,1,1,1,1]
    ships_left_size.each do |n|
      ship = @my_board.ship_random_cordinates(n)
      ship_ready(ship)
    end
    true
  end

  ##the player shoots at another player at a given cell
  #if the cell is empty it's state in @enemy_board is changed to FIRED
  #if there is a ship in the cell it's state is HIT
  def shoot(player, cell)
    @enemy_board.set_cell(cell, FIRED) if player.my_board.cell(cell) == EMPTY
    if [1,2,3,4].include? player.my_board.cell(cell) then
      @enemy_board.set_cell(cell, HIT)
      player.hit_ship cell
      return true
    end
    false
  end
end

##Very Simple AI class
class AI < Player
  ##see Player::shoot
  #the ony difference is that here the cell is an random empty cell
  #empty cell mean it's state is not FIRED or HIT
  def shoot(player)
    target_cell = @enemy_board.random_cordinate
    @enemy_board.set_cell(target_cell, FIRED) if player.my_board.cell(target_cell) == 0
    if [1,2,3,4].include? player.my_board.cell(target_cell) then
      @enemy_board.set_cell(target_cell, HIT)
      player.hit_ship target_cell
      return true
    end
    false
  end
end