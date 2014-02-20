class HighScore
  attr_accessor :users
  def initialize(file_name)
    @users = []
    @file_name = file_name
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
    users_data_coded = ""
    @users.each { |u| users_data_coded = users_data_coded + u.to_s(Cryptogram.new.encode) }
    high_score.write(users_data_coded[0..-2])
    high_score.close
  end

  def add_user(user)
    @users.push user
  end
end

class User
  attr_accessor :name, :password, :wins, :loses, :points
  def to_s(encoder)
    p encoder
    p attributes.map{|n| encoder.call n.to_s}.join('!') + '#'
  end

  def read(str, decoder)
    user_data = str.split("!")
    @name = decoder.call user_data[0]
    @password = decoder.call user_data[1]
    @wins = decoder.call(user_data[2]).to_i
    @loses = decoder.call(user_data[3]).to_i
    @points = decoder.call(user_data[4]).to_i
  end

  def attributes
    [@name, @password, @wins, @loses, @points]
  end
end

class Cryptogram
  def encode
    encoding = Proc.new do |str|
    encoded = String.new str
    str.split(//).each_index { |n| p encoded[n] = (str[n].ord - n - 1).chr}.reduce(:+)
    encoded
    end    
  end

  def decode
    decoding = Proc.new do |str|
    decoded = String.new str
    str.split(//).each_index { |n| p decoded[n] = (str[n].ord + n + 1).chr}.reduce(:+)
    decoded
    end
  end
end