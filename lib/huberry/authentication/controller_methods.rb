module Huberry
	module Authentication
		module ControllerMethods			
			def self.extended(base)
				base.class_eval do
					include InstanceMethods

					cattr_accessor :authentication_message, :authentication_redirect_path, :authentication_model
					self.authentication_message = 'Login to continue'
					self.authentication_redirect_path = '/'
					self.authentication_model = 'User'

					attr_accessor :current_user
					helper_method :current_user, :logged_in?
				end
			end
			
			module InstanceMethods
				protected

          def find_current_user
            self.current_user = self.class.authentication_model.to_s.constantize.find(session[:user_id]) rescue false
          end
					
          def logged_in?
            find_current_user if self.current_user.nil?
            !!self.current_user
          end
					
          def login(user)
            self.current_user = user
            session[:user_id] = user.id
          end
					
          def login_required
            unauthenticated unless logged_in?
          end
					
          def logout
            self.current_user = false
            session[:user_id] = nil
          end
					
          def unauthenticated
            flash[:error] = self.class.authentication_message.to_s
            redirect_to respond_to?(self.class.authentication_redirect_path) ? send(self.class.authentication_redirect_path) : self.class.authentication_redirect_path.to_s
            false
          end
			end
		end
	end
end