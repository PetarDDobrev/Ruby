require 'minitest/autorun'
require '../board'
require '../../renders/console'

class TestBoard < MiniTest::Unit::TestCase
  def setup
    @board = Board.new
    @ship = Ship.new 3
    @ship.set_position('A2','A4')
  end

  def test_set_cell
    cells = ['E1','C3','B4', 'J8', 'H10','G6','I8']
    state = FIRED
    cells.each do |c|
      @board.set_cell c, state
      assert_equal @board.cell(c), state
    end
  end
  
  def test_put_ship
    assert_equal @board.put_ship(@ship), true
    @ship.cordinates.each do |c|
      assert_equal @board.cell(c), @ship.size
    end
    assert_equal @board.put_ship(@ship), false
  end
end