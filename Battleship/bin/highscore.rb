##class managing highscore system
class HighScore
  attr_accessor :users
  ##creates a highscore object
  #the given parameter is an existing file of users
  #@users is array with all the users
  #load is called to fill the @users array with all the
  #users from the given file

  def initialize(file_name)
    @users = []
    @file_name = file_name
    load
  end

  ##fills @users with all users from the file @file_name
  #uses Crytrogram class to decode user information
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

  ##sorts @users by @points parameter and then saves every user
  #in the file @file_name
  #each user data is encrypted with Cryptogram class
  def save
    high_score = File.open(@file_name,"w")
    users_data_coded = ''
    @users.sort! { |a,b| b.points <=> a.points }
    @users.each { |u| users_data_coded = users_data_coded + u.to_s(Cryptogram.new.encode) }
    high_score.write(users_data_coded[0..-2])
    high_score.close
  end

  ##adds a user to @users
  def add_user(user)
    @users.push user
  end

  ##checks if a user with given name exists
  #if it does it returns [true,u] where u is the found user
  #if not return [false,User.new]
  def user_exists?(name)
    @users.each do |u|
      return [true,u] if u.name.upcase == name.upcase
    end
    [false, User.new]
  end

  ##checks user's password
  #user is the user that is checked
  #exists tells if the the user is new(false) or existing(true)
  #password is the pasword entered by the user
  #returns true if the password is correct(old user)
  #or if it is set(new user)
  #returns false if the player wants to change username
  #or the password is wrong
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

##class User used for highscore system
class User
  attr_accessor :name, :password, :wins, :losses, :points
  ##creates an empty object User
  def initialize
    @name = ''
    @password = ''
    @wins = @losses = @points = 0
  end

  ##sets all parametars with teh given arguments
  def set_user(name,password,wins,losses,points)
    @name, @password = name, password
    @wins, @losses, @points = wins, losses, points
  end

  ##encodes user data into string
  #the argument is a block containing encoding algorithm
  def to_s(encoder)
    encoder
    attributes.map{|n| encoder.call n.to_s}.join('!') + '#'
  end

  ##decodes user date from a stirng and a given
  #block containing decoding algorith
  def read(str, decoder)
    user_data = str.split('!')
    @name = decoder.call user_data[0]
    @password = decoder.call user_data[1]
    @wins = decoder.call(user_data[2]).to_i
    @losses = decoder.call(user_data[3]).to_i
    @points = decoder.call(user_data[4]).to_i
  end

  ##adds points ot the user total points
  def add_points(points)
    @points = @points + points
  end

  ##adds one more win
  def win
    @wins = @wins.next
  end

  ##adds one more loss
  def lose
    @losses = @losses.next
  end

  ##returns an array of the attributes
  def attributes
    [@name, @password, @wins, @losses, @points]
  end
end

##class Cryptogram is used of encoding and decoding strings
class Cryptogram
  ##returns a block containing encoding algorithm
  def encode
    encoding = Proc.new do |str|
    encoded = String.new str
    str.split(//).each_index { |n| encoded[n] = (str[n].ord - n - 1).chr}.reduce(:+)
    encoded
    end
  end

  ##returns a block containing decodign algorithm
  def decode
    decoding = Proc.new do |str|
    decoded = String.new str
    str.split(//).each_index { |n| decoded[n] = (str[n].ord + n + 1).chr}.reduce(:+)
    decoded
    end
  end
end