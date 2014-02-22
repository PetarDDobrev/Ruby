require_relative 'constants'
require_relative 'ship'

CORDINATES = [[-1,0],[1,0],[0,-1],[0,1]]

#this class represents the game board
class Board
  attr_accessor :board
  ##creates a board object which has only one attribute
  #@board witch is a hash with keys all cells and values states of the cells
  def initialize()
    grid = BOARD_NUMBERS.map{ |x| BOARD_ALPHABET.map{ |y| y + x}}.flatten
    @board = Hash[grid.collect { |k| [k, EMPTY]} ]
  end

  ##changes the state of a given cell
  def set_cell(cell, state)
    @board[cell] = state
  end

  #returns state of a given cell
  def cell(cell)
    @board[cell]
  end

  ##checks if the cordinates of the given ships are available
  #if not return false
  #else changes the state of those cells 
  def put_ship(ship)
    return false if ship.cordinates.map{ |x| @board[x]}.reduce(:+) != EMPTY
    ship.cordinates.map{ |x| @board[x] = ship.size}
    true
  end

  ##returns a random empty cordinate/cell
  def random_cordinate()
    cordinate = BOARD_ALPHABET[rand(10)] + BOARD_NUMBERS[rand(10)]
    while @board[cordinate] != EMPTY
      cordinate = BOARD_ALPHABET[rand(10)] + BOARD_NUMBERS[rand(10)]
    end
    cordinate
  end

  ##returns a new ship with randomized cordinates
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