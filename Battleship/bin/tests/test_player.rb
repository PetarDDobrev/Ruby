require 'minitest/autorun'
require '../player'

class TestPlayer < MiniTest::Unit::TestCase
  def setup
    @player = Player.new
  end

  def test_generate_board_and_ready?
    assert_equal @player.ready? , false
    @player.generate_board
    assert_equal @player.ships.length, 10 
    assert_equal @player.ready? , true   
  end

  def test_ship_hit
    @player.generate_board
    assert_equal @player.ships[0].hit?, false
    @player.ships[0].cordinates.each do |c|
      @player.ship_hit c
      assert_equal @player.ships[0].hit?, true
    end
    assert_equal @player.ships[0].dead?, true
  end
  def test_ship_ready
    ship = Ship.new 4
    ship.set_position('A1', 'A4')
    assert_equal @player.ships_unset[SHIP_SET.reverse[4-1]], 1
    assert_equal @player.ships_unset.values.reduce(:+) , 10
    assert_equal @player.ships.length, 0
    @player.ship_ready(ship)
    assert_equal @player.ships_unset[SHIP_SET.reverse[4-1]], 0
    assert_equal @player.ships_unset.values.reduce(:+) , 9
    assert_equal @player.ships.length, 1
  end
end