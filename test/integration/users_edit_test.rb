require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:nevin)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    patch user_path(@user), params: { user: { name:  "",
                                   email: "user@invalid",
                                   password:              "foo",
                                   password_confirmation: "bar" } }
    assert_template 'users/edit'
  end
  
  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "example user"
    email = "user@example.com"
    patch user_path(@user), params: { user: { name: name,
                                           email: email,
                                           password:              "",
                                           password_confirmation: "" } }
    refute flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
end
