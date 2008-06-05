require File.dirname(__FILE__) + '/init'

class User < ActiveRecord::Base
	uses_authentication
end

class ModelTest < Test::Unit::TestCase
  
  def setup
    create_users_table
  end
  
  def teardown
    drop_all_tables
  end

  def test_should_create_user
    assert_difference 'User.count' do
      create_user
    end
  end

	def test_should_not_create_without_email
		assert_no_difference 'User.count' do
			@user = create_user :email => ''
		end
		assert @user.errors.on(:email)
	end
  
  def test_should_not_create_without_password
    assert_no_difference 'User.count' do
      @user = create_user :password => ''
    end
    assert @user.errors.on(:password)
  end

  def test_should_not_create_without_password_confirmation
    assert_no_difference 'User.count' do
      @user = create_user :password_confirmation => ''
    end
    assert @user.errors.on(:password)
  end
  
  def test_should_generate_salt_on_create
    @user = create_user
    assert !@user.salt.blank?
  end

  def test_should_hash_password_on_create
    @user = create_user
    assert !@user.hashed_password.blank?
  end

  def test_should_destroy
    @user = create_user
    assert_difference 'User.count', -1 do
      @user.destroy
    end
  end
  
  def test_should_authenticate
    @user = create_user
    assert_equal @user, User.authenticate(@user.email, @user.password)
  end
  
  def test_should_not_authenticate_with_invalid_email
    @user = create_user
    assert !User.authenticate('invalid', @user.password)
  end
  
  def test_should_not_authenticate_with_invalid_password
    @user = create_user
    assert !User.authenticate(@user.email, 'invalid')
  end

	def test_should_reset_password
		@user = create_user
		assert !@user.password_changed?
		old_password = @user.password
		
		@user.reset_password('new_password')
		assert_not_equal 'new_password', old_password
		assert_equal 'new_password', @user.password
		assert @user.password_changed?
	end
	
	def test_should_reset_password!
		@user = create_user
		assert @user.reset_password!('new_password')
	end

end