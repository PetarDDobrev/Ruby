require 'io/console'

class Console
  def initialize
  end
  BOARD_ENCODER = {0=>' ', 1=>'S', 2=>'D', 3=>'C', 4=>'B',5=>'F', 6=>'H'}
  ROW_SEPARATOR = '   --------------------------------------- '
  BOARD_TOP = '    A   B   C   D   E   F   G   H   I   J  '
  def draw_board(board)
    rows = (0..9).to_a
    board_values = board.board.values
    board_rows = rows.map{ |x|  board_values.drop(x*10).take 10 }
    full_board = BOARD_TOP + ROW_SEPARATOR
    board_rows.map!{ |x| x.map!{ |y| ' ' + BOARD_ENCODER[y] + ' |'}.reduce(:+)}    
    (0..8).to_a.each { |x| full_board = full_board + (x+1).to_s + ' |' + board_rows[x] + ROW_SEPARATOR}
    full_board = full_board + 10.to_s + '|' + board_rows[9] + ROW_SEPARATOR
    puts full_board.scan(/.{43}/).join("\n")
  end

  def announce_player(player_id)
    puts 'First player is setting up board.' if player_id == 1
    puts 'Second player is setting up board.' if player_id == 2
  end

  def announce_ai
    puts 'Ai player is setting up his board.'
  end

  def draw_menu
    puts '1.Battle a computer'
    puts '2.Hot-seat multiplayer'
    puts '3.exit'
    choice = gets.chomp.to_i
  end
  def setup_board(player)
    player.ships_unset.each {|k, v| puts (player.ships_unset.values.index(v)+1).to_s + ". #{k}s left: #{v}; " }
    p 'Please select type of ship'
    choice = gets.chomp.to_i
  end
  def select_ship(ships_left)
    ships_left.each {|k, v| puts (ships_left.values.index(v)+1).to_s + ". #{k}s left: #{v}; " }
    puts 'Please select type of ship'
    while true
      choice = gets.chomp.to_i - 1
      return choice if ships_left[SHIP_SET[choice]] > 0
      puts 'No more ships of that type please pick another'
    end
  end

  def select_cordinates(ship_size)
    puts 'Write 2 cells which should be HEAD and TAIL of the ship. Only 1 ship can be in one cell!!!.'
    puts "Selected ship size is #{ship_size}. Example A1 A#{(ship_size)}."
    puts 'Write HEAD: '
    head = gets.chomp
    puts 'Write TAIL: '
    tail = gets.chomp
    [head,tail]
  end

  def incorrect_cordinates
    puts 'Incorrect cordinates. Please pick other.'
  end

  def select_cell(board)
    puts 'Please select a cell to shoot at. Example A2'
    cell = gets.chomp
    while board.board.keys.include? cell == false
      puts 'Incorrect cell. Please select another cell to shoot at. Example A2'
      cell = gets.chomp
    end
    cell
  end

  def ai_ready
    puts 'Ai ready to battle'
  end

  def ai_win
    puts 'AI wins the battle!'
  end

  def player_ready(id)
    puts 'First player ready to battle.' if id == 1
    puts 'Second player ready to battle.' if id == 2
  end

  def player_win(id)
    puts 'First player wins to battle!' if id == 1
    puts 'Second player wins to battle!' if id == 2
  end
end