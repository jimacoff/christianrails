module CustomSpecHelpers

  def prepare_admin_user
    @user = User.create!({
      username: 'testuser',
      first_name: 'Test',
      last_name: 'User',
      email: 'user@test.com',
      password: '12345678',
      password_confirmation: '12345678',
      country: 'CA'
    })
    @user.admin = true
    @user.save
    sign_in @user
  end

end
