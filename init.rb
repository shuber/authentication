require 'huberry/authentication/controller_methods'
require 'huberry/authentication/model_methods'

ApplicationController.send :include, Huberry::Authentication::ControllerMethods
ActiveRecord::Base.send :extend, Huberry::Authentication::ModelMethods

$:.unshift File.dirname(__FILE__) + '/lib'