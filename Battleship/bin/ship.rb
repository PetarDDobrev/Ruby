require_relative 'constants'  

class Ship
  attr_accessor :cordinates, :size
  def initialize(size)
    @cordinates = Array.new(size,0)
    @states = Array.new(size,ALIVE)
    @size = size
  end

  def set_position(head, tail)
    #return false if head.length > 3 or tail.size > 3
    head_position = head.split(//,2)
    tail_position = tail.split(//,2)
    return false if not correct_positions(head_position, tail_position)
    if head_position[0] == tail_position[0]
      numbers = (0..@size-1).to_a
      @cordinates = numbers.map{ |x| head_position[0] + (x + head_position[1].ord).chr}
    else
      numbers = (0..@size-1).to_a
      @cordinates = numbers.map{ |x| (head_position[0].ord + x).chr + head_position[1]}
    end
    true

  end

  def correct_positions(head, tail)
    cordiantes = (head.zip tail).flatten
    chars_allowed = (BOARD_ALPHABET.zip BOARD_NUMBERS).flatten
    return false if not cordiantes.all? {|x| chars_allowed.member? x}
    return false if head[0] != tail[0] and head[1] != tail[1]
    return false if head[0] == tail[0] and (head[1].ord - tail[1].ord).abs != @size - 1
    return false if head[1] == tail[1] and (head[0].ord - tail[0].ord).abs != @size - 1
    true
  end

  def dead?
    return true if @states.reduce(:+) == 0
    false
  end

end

 # a = ["A1", "A4"]
 # s =Ship.new(4)
 # p a[0], a[1] , c = a[0].split(//,2), b = a[1].split(//,2)
 # p s.correct_positions(c, b),s.set_position(a[0], a[1])