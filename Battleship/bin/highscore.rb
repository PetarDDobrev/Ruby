class HighScore
  attr_accessor :users
  def initialize(file_name)
    @users = []
    @file_name = file_name
    load
  end

  def load
    @users = []
    users_data_coded = File.read(@file_name)
    return if users_data_coded.length == 0
    users_data_coded.split('#').each do |u| 
      current_user = User.new
      current_user.read(u,Cryptogram.new.decode)
      @users.push(current_user)
    end
  end

  def save
    high_score = File.open(@file_name,"w")
    users_data_coded = ''
    @users.sort! { |a,b| b.points <=> a.points }
    @users.each { |u| users_data_coded = users_data_coded + u.to_s(Cryptogram.new.encode) }
    high_score.write(users_data_coded[0..-2])
    high_score.close
  end

  def add_user(user)
    @users.push user
  end

  def user_exists?(name)
    @users.each do |u|
      return [true,u] if u.name.upcase == name.upcase
    end

    [false, User.new]
  end

  def correct_password?(user,exists,password)
    if exists then
      return false if user.password == 'n'
      return true if user.password == password
    else
      user.password = password
      return true
    end
    false 
  end

  
end

class User
  attr_accessor :name, :password, :wins, :losses, :points
  def initialize
    @name = ''
    @password = ''
    @wins = @losses = @points = 0
  end
  
  def set_user(name,password,wins,losses,points)
    @name, @password = name, password
    @wins, @losses, @points = wins, losses, points
  end
  
  def to_s(encoder)
    encoder
    attributes.map{|n| encoder.call n.to_s}.join('!') + '#'
  end

  def read(str, decoder)
    user_data = str.split('!')
    @name = decoder.call user_data[0]
    @password = decoder.call user_data[1]
    @wins = decoder.call(user_data[2]).to_i
    @losses = decoder.call(user_data[3]).to_i
    @points = decoder.call(user_data[4]).to_i
  end

  def add_points(points)
    @points = @points + points
  end

  def win
    @wins = @wins.next
  end

  def lose
    @losses = @losses.next
  end

  def attributes
    [@name, @password, @wins, @losses, @points]
  end
end

class Cryptogram
  def encode
    encoding = Proc.new do |str|
    encoded = String.new str
    str.split(//).each_index { |n| encoded[n] = (str[n].ord - n - 1).chr}.reduce(:+)
    encoded
    end    
  end

  def decode
    decoding = Proc.new do |str|
    decoded = String.new str
    str.split(//).each_index { |n| decoded[n] = (str[n].ord + n + 1).chr}.reduce(:+)
    decoded
    end
  end
end