require 'minitest/autorun'
require '../highscore'


class TestHighScoreSystem < MiniTest::Unit::TestCase
  def setup
    @high_score = HighScore.new("test.hsc")
    @cryptogram = Cryptogram.new
    @user = User.new
    data = ["ime","parola",5,1,14]
    @user.set_user(data[0],data[1],data[2],data[3],data[4])
  end

  def test_set_user
    data = ["ime","parola","2","0","6"]
    @user.set_user(data[0],data[1],data[2],data[3],data[4])
    assert_equal @user.attributes, data
  end

  def test_user_add_points
    current_points = @user.points
    points = 10
    @user.add_points(10)
    assert_equal @user.points, current_points+points
  end

  def test_encode_decode
    test_string = "qwertyuiop"
    encoded = @cryptogram.encode.call test_string
    assert_equal @cryptogram.decode.call(encoded), test_string    
    test_string = "asdfghjkl"
    encoded = @cryptogram.encode.call test_string
    assert_equal @cryptogram.decode.call(encoded), test_string    
    test_string = "123456789"
    encoded = @cryptogram.encode.call test_string
    assert_equal @cryptogram.decode.call(encoded), test_string
    test_string = "gjfdiu8m5cn2m3098u3298du8mhpiushmoehiohoua98n3uhmugvehcuhskx"
    encoded = @cryptogram.encode.call test_string
    assert_equal @cryptogram.decode.call(encoded), test_string
  end

  def test_user_to_s_and_read
    user = User.new
    test_string = @user.to_s @cryptogram.encode
    user.read test_string, @cryptogram.decode
    assert_equal user.attributes, @user.attributes
  end

  def test_highscore_save_load_add_user
    @high_score.users = []
    puts "\n", user_number = @high_score.users.length
    (1..10).each do |n|
      user = User.new
      test_string = @user.to_s @cryptogram.encode
      user.read test_string, @cryptogram.decode
      user.add_points n*10
      @high_score.add_user user
      assert_equal user_number+n, @high_score.users.length
    end
    before_save = @high_score.users.sort{ |a,b| b.points <=> a.points }.map{|u| u.attributes}
    @high_score.save
    @high_score.load
    after_save = @high_score.users.map{|u| u.attributes}
    assert_equal before_save, after_save
  end
end