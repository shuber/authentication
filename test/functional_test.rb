require File.dirname(__FILE__) + '/init'

class User < ActiveRecord::Base
	acts_as_authenticated
end

class UnitTest < Test::Unit::TestCase
end