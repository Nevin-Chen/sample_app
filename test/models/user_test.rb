require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", 
    password: 'foobar', password_confirmation: 'foobar')
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.name = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@@barbaz.com foo@barbaz..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email address should be saved as lowercase" do
    email_address = 'tEST@eXample.Com'
    @user.email = email_address
    @user.save
    assert_equal email_address.downcase, @user.reload.email
  end
  
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy 
    end
  end
  
  test "should follow and unfollow a user" do
    nevin = users(:nevin)
    bob = users(:bob)
    assert_not nevin.following?(bob)
    nevin.follow(bob)
    assert nevin.following?(bob)
    assert bob.followers.include?(nevin)
    nevin.unfollow(bob)
    assert_not nevin.following?(bob)
    # user can't follow themselves
    nevin.follow(nevin)
    assert_not nevin.following?(nevin)
  end
  
  test "should have the right posts" do
    nevin = users(:nevin)
    bob   = users(:bob)
    linda = users(:linda)
    linda.microposts.each do |post_following|
      assert nevin.feed.include?(post_following)
    end
    # Posts from self
    nevin.microposts.each do |post_self|
      assert nevin.feed.include?(post_self)
    end
    # Posts from unfollowed user
    bob.microposts.each do |post_unfollowed|
      assert_not nevin.feed.include?(post_unfollowed)
    end
  end
end
