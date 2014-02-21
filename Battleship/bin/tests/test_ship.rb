require 'minitest/autorun'
require '../ship'

class TestShip < MiniTest::Unit::TestCase
  def setup
    @ship = Ship.new 4
  end

  def test_ship_isnt_dead
    assert_equal @ship.dead?, false
  end

  def test_ship_isnt_hit
    assert_equal @ship.dead?, false
  end

  def test_correct_postitions
    assert_equal @ship.correct_positions(["A","1"], ["A","4"]), true
    assert_equal @ship.correct_positions(["A","1"], ["D","1"]), true
    assert_equal @ship.correct_positions(["A","4"], ["A","1"]), true
    assert_equal @ship.correct_positions(["D","1"], ["A","1"]), true
    assert_equal @ship.correct_positions(["A","1"], ["A","3"]), false
    assert_equal @ship.correct_positions(["A","1"], ["A","5"]), false
    assert_equal @ship.correct_positions(["A","1"], ["C","1"]), false
    assert_equal @ship.correct_positions(["A","1"], ["4","A"]), false
    assert_equal @ship.correct_positions(["23","12"], ["4","A"]), false
    assert_equal @ship.correct_positions(["A","1"], ["B","4"]), false
    assert_equal @ship.correct_positions(["C","1"], ["B","4"]), false
    assert_equal @ship.correct_positions(["A","1"], ["D","2"]), false
  end
end