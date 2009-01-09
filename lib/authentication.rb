require 'huberry/authentication/controller_methods'
require 'huberry/authentication/model_methods'

ActionController::Base.extend Huberry::Authentication::ControllerMethods
ActiveRecord::Base.extend Huberry::Authentication::ModelMethods