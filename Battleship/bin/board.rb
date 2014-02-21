require_relative 'constants'
require_relative 'ship'
CORDINATES = [[-1,0],[1,0],[0,-1],[0,1]]
class Board
  attr_accessor :board
  def initialize()
    grid = BOARD_NUMBERS.map{ |x| BOARD_ALPHABET.map{ |y| y + x}}.flatten
    @board = Hash[grid.collect { |k| [k, EMPTY]} ]
  end

  def set_cell(cell, state)
    @board[cell] = state
  end 
  
  def cell(cell)
    @board[cell]
  end

  def put_ship(ship)
    return false if ship.cordinates.map{ |x| @board[x]}.reduce(:+) != EMPTY
    ship.cordinates.map{ |x| @board[x] = ship.size}
    true
  end

  def random_cordinate()
    cordinate = BOARD_ALPHABET[rand(10)] + BOARD_NUMBERS[rand(10)]
    while @board[cordinate] != 0
      cordinate = BOARD_ALPHABET[rand(10)] + BOARD_NUMBERS[rand(10)]
    end
    cordinate
  end

  def ship_random_cordinates(ship_size)
    ship = Ship.new ship_size
    ship_size = ship_size - 1
    flag = false
    while not flag      
      cordinate_x = random_cordinate
      head_position = cordinate_x.split(//,2)
      cordinate_y = CORDINATES.map{|x| (head_position[0].ord + x[0]*ship_size).chr + (head_position[1].to_i+ x[1]*ship_size).to_s}
      cordinate_y = cordinate_y[rand(4)]
      if ship.set_position(cordinate_x,cordinate_y)
        flag = put_ship(ship)
      end
    end
    ship
  end
end