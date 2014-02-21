require_relative 'constants'
require_relative 'ship'
require_relative 'board'
require_relative 'highscore'

class Player
  attr_accessor :user, :my_board, :enemy_board, :ships_unset, :ships
  def initialize
    @user = User.new
    @my_board = Board.new
    @enemy_board = Board.new
    @ships = []
    @ships_unset = Hash[SHIP_SET.collect { |k| [k, SHIP_SET.index(k) + 1]} ]
  end

  def ready?
    @ships_unset.values.reduce(:+) == 0
  end

  def ship_ready(ship)
    ship_type = SHIP_SET.reverse[ship.size-1]
    @ships.push ship
    @ships_unset[ship_type] = @ships_unset[ship_type] - 1 
  end
  
  def ship_hit(cell)
    @ships.each do |ship|
      ship.hit cell
    end 
  end

  def generate_board
    ships_left_size = [4,3,3,2,2,2,1,1,1,1]
    ships_left_size.each do |n|
      ship = @my_board.ship_random_cordinates(n)
      ship_ready(ship)
    end
    true
  end
  

  def shoot(player, cell)
    @enemy_board.set_cell(cell, FIRED) if player.my_board.cell(cell) == 0
    if [1,2,3,4].include? player.my_board.cell(cell) then
      @enemy_board.set_cell(cell, HIT)
      player.ship_hit cell
      return true
    end
    false
  end
end

class AI < Player
  def shoot(player)
    target_cell = @enemy_board.random_cordinate
    @enemy_board.set_cell(target_cell, FIRED) if player.my_board.cell(target_cell) == 0
    if [1,2,3,4].include? player.my_board.cell(target_cell) then
      @enemy_board.set_cell(target_cell, HIT)
      player.ship_hit target_cell
      return true
    end
    false
  end
end