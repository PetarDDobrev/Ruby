require_relative 'constants'
require_relative 'ship'
require_relative 'board'

class Player
  attr_accessor :id, :my_board, :enemy_board, :ships_unset
  def initialize(id)
    @id = id
    @my_board = Board.new
    @enemy_board = Board.new
    @ships = Hash[SHIP_SET.collect { |k| [k, []]} ]
    @ships_unset = Hash[SHIP_SET.collect { |k| [k, SHIP_SET.index(k) + 1]} ]
  end

  def ready?
    @ships_unset.values.reduce(:+) == 0
  end

  def ship_ready(ship)
    ship_type = SHIP_SET.reverse[ship.size-1]
    @ships[ship_type].push ship
    @ships_unset[ship_type] = @ships_unset[ship_type] - 1 
  end

  def generate_board
    ships_left_size = [4,3,3,2,2,2,1,1,1,1]
    ships_left_size.each do |n|
      ship = @my_board.random_cordinates(n)
      ship_ready(ship)
    end
    true
  end

  def random_cordinates(ship_size)
    cordinate_x = BOARD_ALPHABET[rand(10)]
  end
end