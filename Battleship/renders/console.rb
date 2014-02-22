require 'io/console'

##this class is for console rendering of the game
class Console
  def initialize
  end
  ##this is used to represent board information in more understandable way
  # 0-'' empty, 1-'S' submarine, 2-'D' destroyer
  # 3-'Ç' cruiser, 4-'B' battleship, 5-'F' Fired, 5-'H' Hit
  BOARD_ENCODER = {0=>' ', 1=>'S', 2=>'D', 3=>'C', 4=>'B',5=>'F', 6=>'H'}

  ##used for the board table layout
  ROW_SEPARATOR = '   --------------------------------------- '

  ##used for the board table layout
  BOARD_TOP = '    A   B   C   D   E   F   G   H   I   J  '

  ##draws a given Board object
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

  ##puts alot of newlines.
  #used for HotSeat game. When a player has set all his ships
  #puts new lines so teht the next_player wont see his board
  def next_player
    puts "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n
          \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
  end

  ##prints out the current turn of the current game
  def current_turn(turn)
    puts "\n\n" + "TURN : #{turn}".center(50)
  end

  ##prints menu options and waits for input
  #no need for input restrictions
  def draw_menu
    puts '1.Battle a computer'
    puts '2.Hot-seat multiplayer'
    puts '3.High scores'
    puts '4.exit'
    choice = gets.chomp.to_i
  end

  ##prints the ships left of each type of a player, ship_left is a Player.ships_unset object
  #and waits for input
  #if the input is not number from [1,2,3,4] then error is printed and waits for new input
  #if the there are no more ships of selected type and error iprinted and waits for new input
  def select_ship(ships_left)
    ships_left.each {|k, v| puts (ships_left.values.index(v)+1).to_s + ". #{k}s left: #{v}; " }
    puts 'Please select type of ship'
    while true
      choice = gets.chomp.to_i
      if not [1,2,3,4].include? choice then
        puts 'Incorrect number. Please choose number between 1 and 4'
        next
      end
      return choice - 1 if ships_left[SHIP_SET[choice-1]] > 0
      puts 'No more ships of that type please pick another'
    end
  end

  ##returns ana array that has the head and tail cordinate of a ship
  #no input restrinctions needed
  def select_cordinates(ship_size)
    puts 'Write 2 cells which should be HEAD and TAIL of the ship. Only 1 ship can be in one cell!!!.'
    puts "Selected ship size is #{ship_size}. Example A1 A#{(ship_size)}."
    puts 'Write HEAD:'
    head = gets.chomp
    puts 'Write TAIL:'
    tail = gets.chomp
    [head,tail]
  end

  ##prints and error message for incorect cordiantes
  def incorrect_cordinates
    puts 'Incorrect cordinates. Please pick other.'
  end

  ##selecting a cell(example 'A1')
  #returns a cell
  #board argument is used to getting array of all possible cells
  #this array is used for checkign the input
  #if the input is not in the array error is printed and waits for new input 
  def select_cell(board)
    puts 'Please select a cell to shoot at. Example A2'
    cell = gets.chomp
    while board.board.keys.include? cell == false
      puts 'Incorrect cell. Please select another cell to shoot at. Example A2'
      cell = gets.chomp.upcase
    end
    cell
  end

  ##returns a string which is used for user's name
  #the string must not be longer then 10 symbols
  def username
    name = "qwertyuiopa"
    while name.length > 10
      puts 'Please write your name(max 10 symbols):'
      name = gets.chomp
    end
    name
  end

  ##returns a string which is used for user's password
  #the string must not be longer then 10 symbols
  #user argument is used for printing infromation
  #exist is a bool that shos if the user is new or already in
  #the high score system
  #depending on exist different messages are printed
  def password(user, exists)
    if exists then
      puts "Welcome #{user.name}, please enter your password."
      puts "If you want to sign with on username type 'n'."
    else
      puts "You created a new user with name #{user.name}."
      puts 'Please type a password or just press enter for no password.'
    end
    password = "qwertyuiopa"
    while password.length > 10
      puts "The password must not be more then 10 symbols!"
      password = gets.chomp
    end
    password
  end

  ##prints a high score table
  #users is and array of users already sorted by User.points
  def print_highscore_table(users)
    puts "\n\n" + "HIGH SCORES".center(50) + "\n\n"
    puts "name".ljust(15) + "points".rjust(15) + "wins".rjust(10) + "losses".rjust(10) + "\n\n"
    users.each { |u| puts "#{u.name}".ljust(15) + "#{u.points}".rjust(15) + "#{u.wins}".rjust(10) + "#{u.losses}".rjust(10) + "\n"}
  end 

  ##prints a user information
  #used when printing only one user, for instans when player signs in/signs up
  def print_user(user)
    puts "\n#{user.name} has #{user.wins} wins, #{user.losses} losses and #{user.points} points\n"
  end

  ##prints who is player thath have to set his board now
  def announce_player(name)
    puts "#{name} is setting up board."
  end

  ##prints that the AI is setting up the board
  def announce_ai
    puts 'Ai player is setting up his board.'
  end
  
  ##prints that AI is ready for battle
  def ai_ready
    puts 'Ai ready to battle'
  end

  ##prints that AI wins the battle
  def ai_win
    puts 'AI wins the battle!'
  end

  ##prints a player is ready to battle, by given name
  def player_ready(name)
    puts "#{name} is ready to battle."
  end

  ##prints that a player won the battle
  #name is the name of the player
  def player_win(name)
    puts "#{name} wins the battle."
  end

  ##used for printing :text
  def message(text)
    puts text
  end
end