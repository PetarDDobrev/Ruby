require_relative 'constants'  

#ship class
class Ship
  attr_accessor :cordinates, :size, :states
  ##creates ship object
  #ship object is initialized with size of 1,2,3,4
  #cordinates is array of the cells which are occupied by the ship
  #states is array of contitions of each cordinate Dead/Alive
  def initialize(size)
    @cordinates = Array.new(size,0)
    @states = Array.new(size,ALIVE)
    @size = size
  end

  ##sets the position of teh ship
  #head and tail are cordinates to the to ends of the ship,
  #for instance 'A2', 'D5'
  #if the ship is size 1 head == tail  
  def set_position(head, tail)
    head_position = head.split(//,2)
    tail_position = tail.split(//,2)
    return false if not correct_positions(head_position, tail_position)
    head_value = BOARD_ALPHABET.index(head_position[0]) + BOARD_NUMBERS.index(head_position[1])
    tail_value = BOARD_ALPHABET.index(tail_position[0]) + BOARD_NUMBERS.index(tail_position[1])
    if head_value > tail_value
      set_tail_to_head(tail_position, head_position)
    else
      set_head_to_tail(head_position, tail_position)
    end
    true
  end

  ##sets the positions from head to tail
  #here head and tail are arrays of type ['A','2'], ['D','10']
  #for example head=['A','1'], tail=['A','4'] the ship.cordinates
  #will be ['A1','A2','A3','A4'] 
  def set_head_to_tail(head, tail)
    if head[0] == tail[0]
      numbers = (0..@size-1).to_a
      @cordinates = numbers.map{ |x| head[0] + (x + head[1].ord).chr}
    else
      numbers = (0..@size-1).to_a
      @cordinates = numbers.map{ |x| (head[0].ord + x).chr + head[1]}
    end
  end

  ##sets the positions from tail to head
  #here head and tail are arrays of type ['A','2'], ['D','10']
  #for example head=['A','1'], tail=['A','4'] the ship.cordinates
  #will be ['A4','A3','A2','A1']
  def set_tail_to_head(head, tail)
    if head[0] == tail[0]
      numbers = (0..@size-1).to_a
      @cordinates = numbers.map{ |x| head[0] + (tail[1].ord - x).chr}
    else
      numbers = (0..@size-1).to_a
      @cordinates = numbers.map{ |x| (tail[0].ord - x).chr + head[1]}
    end
  end

  ##checks if the given head and tail are correct
  #here head and tail are cordinates like 'A1','B1' and so on
  #if head or tail is 'Q1' or 'A11' it will return false
  #also if head and tail are not in one horizontal or one vertical
  #the function will return false
  def correct_positions(head, tail)
    cordiantes = (head.zip tail).flatten
    chars_allowed = (BOARD_ALPHABET.zip BOARD_NUMBERS).flatten
    return false if not cordiantes.all? {|x| chars_allowed.member? x}
    return false if head[0] != tail[0] and head[1] != tail[1]
    return false if head[0] == tail[0] and (head[1].ord - tail[1].ord).abs != @size - 1
    return false if head[1] == tail[1] and (head[0].ord - tail[0].ord).abs != @size - 1
    true
  end

  #checks if the ship is dead: if all of his cordinates are hit,
  #by checking @states
  def dead?
    return true if @states.reduce(:+) == 0
    false
  end

  #checks if the ship has been hit at least one time, by checking
  #@states
  def hit?
     return true if @states.reduce(:+) < @size
    false
  end

  ##check if the given cell is one of the ships cordinates
  #and if it is it 'hits' it
  def hit(cell)
    cell_index = @cordinates.index(cell)
    @states[cell_index] = DEAD unless cell_index == nil
  end
end