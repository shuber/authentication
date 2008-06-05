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
	  uses_authentication
	end
	
	class ApplicationController < ActionController::Base
	  # Accepts an optional hash of options
	  #   :message - The error flash message to set when unauthenticated (defaults to 'Login to continue')
	  #   :redirect_path - The path to redirect to when unauthenticated (can be a symbol of a method) (defaults to '/')
	  #   :user_model - The model that uses authentication (defaults to User)
	  uses_authentication
	end
	
	class UsersController < ApplicationController
	  before_filter :login_required, :only => [:index]
	
	  def index
	    render :text => 'test'
	  end
	end


Contact
-------

Problems, comments, and suggestions all welcome: [shuber@huberry.com](mailto:shuber@huberry.com)