module UserTestHelper
  
  def create_user(options = {})
    User.create(valid_user_hash(options))
  end
  
  def valid_user_hash(options = {})
    { :email => 'test@test.com', :password => 'test', :password_confirmation => 'test' }.merge(options)
  end
  
end