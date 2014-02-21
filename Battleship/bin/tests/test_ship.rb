require 'minitest/autorun'
require '../ship'

class TestShip < MiniTest::Unit::TestCase
  def setup
    @ship = Ship.new 4
    @ship.set_position('A1','A4')
  end

  def test_ship_isnt_dead
    assert_equal @ship.dead?, false
  end

  def test_ship_isnt_hit
    assert_equal @ship.hit?, false
  end

  def test_ship_hit
    assert_equal @ship.hit?, false
    @ship.hit @ship.cordinates[0]
    assert_equal @ship.hit?, true
    @ship.hit @ship.cordinates[1]
    @ship.hit @ship.cordinates[2]
    assert_equal @ship.dead?, false
    @ship.hit @ship.cordinates[3]
    assert_equal @ship.dead?, true
  end

  def test_correct_postitions
    assert_equal @ship.correct_positions(['A','1'], ['A','4']), true
    assert_equal @ship.correct_positions(['A','1'], ['D','1']), true
    assert_equal @ship.correct_positions(['A','4'], ['A','1']), true
    assert_equal @ship.correct_positions(['D','1'], ['A','1']), true
    assert_equal @ship.correct_positions(['A','1'], ['A','3']), false
    assert_equal @ship.correct_positions(['A','1'], ['A','5']), false
    assert_equal @ship.correct_positions(['A','1'], ['C','1']), false
    assert_equal @ship.correct_positions(['A','1'], ['4','A']), false
    assert_equal @ship.correct_positions(['23','12'], ['4','A']), false
    assert_equal @ship.correct_positions(['A','1'], ['B','4']), false
    assert_equal @ship.correct_positions(['C','1'], ['B','4']), false
    assert_equal @ship.correct_positions(['A','1'], ['D','2']), false
  end

  def test_set_position
    @ship.set_position('A1','A4')
    assert_equal @ship.cordinates, ['A1', 'A2', 'A3', 'A4']
    @ship.set_position('A4','A1')
    assert_equal @ship.cordinates, ['A4', 'A3', 'A2', 'A1']
    @ship.set_position('A1','D1')
    assert_equal @ship.cordinates, ['A1', 'B1', 'C1', 'D1']
    @ship.set_position('D1','A1')
    assert_equal @ship.cordinates, ['D1', 'C1', 'B1', 'A1']    
  end
end