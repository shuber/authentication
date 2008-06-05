require File.dirname(__FILE__) + '/init'

class User < ActiveRecord::Base
	uses_authentication
end

class UnitTest < Test::Unit::TestCase
end