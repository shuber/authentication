authentication
==============

A rails gem/plugin that handles authentication


Installation
------------

	gem install shuber-authentication --source http://gems.github.com
	OR
	script/plugin install git://github.com/shuber/authentication.git


Usage
-----

### Model ###

Simply call `uses_authentication` in your model like so:

	class User < ActiveRecord::Base
	  # Accepts an optional hash of options
	  #   :login_field - The field to use for logins (e.g. username or email) (defaults to :email)
	  #   :password_field - (defaults to :password)
	  #   :hashed_password_field - (defaults to :hashed_password)
	  #   :salt_field - (defaults to :salt)
	  uses_authentication :login_field => :username
	end

A few helpful methods will now be available for your model:

	# Class method that authenticates a user based on a login and password - returns a user instance or false
	User.authenticate(login, password)
	
	# Checks if the password passed to it matches the current user instance's password
	authenticated?(password)
	
	# Checks if the current user instance's password has just been changed
	password_changed?
	
	# Resets the password - will generate a new random password if one is not specified
	reset_password(new_password = nil)
	
	# Resets the password and saves - will generate a new random password if one is not specified
	reset_password!(new_password = nil)


### Controller ###

Simply add `before_filter :authentication_required` for any actions that require authentication. The `:model` will then be searched 
for a record with the id found in the `session[options[:session_field]`. The result of that query is stored in a controller instance 
method called `current_user`. If a record could not be found, the controller's `unauthenticated` instance method is called which simply 
redirects with a flash message. You can overwrite this method to change this behavior.

	class UsersController < ApplicationController
	  before_filter :authentication_required, :only => [:index]

	  def index
	    render :text => current_user.id.to_s
	  end
	end

A few helpful instance methods are available for your controller:

	# Returns the current user or nil if a user is not logged in
	current_user
	
	# Checks if the current user is authenticated
	logged_in?
	
	# Login a user
	login(user)
	
	# Logout the current user
	logout

`current_user` and `logged_in?` are also helper methods so you can use them in your views.


### Controller options ###

Your controller has a class method called `authentication_options` which contains a hash with default options. You can change 
these like so:

	class ApplicationController < ActionController::Base
	  self.authentication_options.merge!{ :message => 'You are not authenticated', :redirect_to => :new_session_path }
	end

The default controller authentication\_options are:

	# The type of flash message to use when authentication fails. Defaults to :error.
	:flash_type
	
	# The flash message to use when authentication fails. If set to false, no flash is set. Defaults to 'Login to continue'.
	:message
	
	# The model to authenticate with. Defaults to 'User'
	:model
	
	# The session field name to store the current_user's id. Defaults to "#{options[:model].to_s.underscore}_id".to_sym (e.g. :user_id)
	:session_field
	
	# The path to redirect to if authentication fails. Accepts a string or a symbol representing an instance method to call. 
	# Defaults to '/'
	:redirect_to


Contact
-------

Problems, comments, and suggestions all welcome: [shuber@huberry.com](mailto:shuber@huberry.com)