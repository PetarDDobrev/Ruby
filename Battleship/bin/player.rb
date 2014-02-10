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
    p ship_type = SHIP_SET.reverse[ship.size-1]
    p @ships[ship_type].push ship
    @ships_unset[ship_type] = @ships_unset[ship_type] - 1 
  end
end

#p Hash[SHIP_SET.collect { |k| [k, []]} ]
