require 'io/console'

class Console
  def initialize
  end
  BOARD_ENCODER = {0=>' ', 1=>'S', 2=>'F'}
  ROW_SEPARATOR = '   --------------------------------------- '
  BOARD_TOP = '    A   B   C   D   E   F   G   H   I   J  '
  def draw_board(board)
    rows = (0..9).to_a
    board_values = board.values
    board_rows = rows.map{ |x|  board_values.drop(x*10).take 10 }
    full_board = BOARD_TOP + ROW_SEPARATOR
    board_rows.map!{ |x| x.map!{ |y| ' ' + BOARD_ENCODER[y] + ' |'}.reduce(:+)}    
    (0..8).to_a.each { |x| full_board = full_board + (x+1).to_s + ' |' + board_rows[x] + ROW_SEPARATOR}
    full_board = full_board + 10.to_s + '|' + board_rows[9] + ROW_SEPARATOR
    puts full_board.scan(/.{43}/).join("\n")
  end
  def draw_menu
    p '1.Battle a computer'
    p '2.Hot-seat multiplayer'
    p '3.exit'
    choice = gets.chomp.to_i
  end
  def setup_board(player)
    player.ships_unset.each {|k, v| puts (player.ships_unset.values.index(v)+1).to_s + ". #{k}s left: #{v}; " }
    p 'Please select type of ship'
    choice = gets.chomp.to_i
  end
  def select_ship(ships_left)
    ships_left.each {|k, v| puts (ships_left.values.index(v)+1).to_s + ". #{k}s left: #{v}; " }
    p 'Please select type of ship'
    while true
      choice = gets.chomp.to_i - 1
      return choice if ships_left[SHIP_SET[choice]] > 0
      p 'No more ships of that type please pick another'
    end
  end

  def select_cordinates(ship_size)
    p 'Write 2 cells which should be HEAD and TAIL of the ship. Only 1 ship can be in one cell!!!.'
    puts "Selected ship size is #{ship_size}. Example A1 A#{(ship_size)}."
    p 'Write HEAD: '
    head = gets.chomp
    p 'Write TAIL: '
    tail = gets.chomp
    [head,tail]
  end
end

