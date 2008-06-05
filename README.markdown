Huberry::Authentication
=======================

A rails plugin that handles authentication


Installation
------------

	script/plugin install git://github.com/shuber/authentication.git


Example
-------

	class User < ActiveRecord::Base
	  # Accepts an optional hash of options
	  #   :login_field - The field to use for logins (e.g. username or email) (defaults to :email)
	  uses_authentication :login_field => :username
	end
	
	class ApplicationController < ActionController::Base
	  # Set optional authentication options here
	  #   self.authentication_message = The error flash message to set when unauthenticated (defaults to 'Login to continue')
	  #   self.authentication_redirect_path = The path to redirect to when unauthenticated (can be a symbol of a method) (defaults to '/')
	  #   self.authentication_model = The model that uses authentication (defaults to 'User')
	end
	
	class UsersController < ApplicationController
	  before_filter :login_required, :only => [:index]
	
	  def index
	    render :text => 'test'
	  end
	end	


Controller Methods
------------------
	
	# Returns the current user or nil if a user is not logged in
	current_user
	
	# Checks if the current user is authenticated
	logged_in?
	
	# Login a user
	login(user)
	
	# A before filter to require authentication - redirects to the controller class's authentication_redirect_path if unauthenticated
	login_required
	
	# Logout the current user
	logout


Model Methods
-------------

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


Contact
-------

Problems, comments, and suggestions all welcome: [shuber@huberry.com](mailto:shuber@huberry.com)