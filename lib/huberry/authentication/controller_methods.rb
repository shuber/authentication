module Huberry
	module Authentication
		module ControllerMethods			
			def uses_authentication(options = {})
				include InstanceMethods
				
				cattr_accessor :unauthenticated_message, :unauthenticated_redirect_path, :user_model
				self.unauthenticated_message = options[:message] || 'Login to continue'
				self.unauthenticated_redirect_path = options[:redirect_path] || '/'
				self.user_model = options[:user_model] || User

				attr_accessor :current_user
				helper_method :current_user, :logged_in?
			end
			
			module InstanceMethods
				protected

          def find_current_user
            self.current_user = self.class.user_model.find_by_id(session[:user_id]) || false
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
            flash[:error] = self.class.unauthenticated_message.to_s
            redirect_to respond_to?(self.class.unauthenticated_redirect_path) ? send(self.class.unauthenticated_redirect_path) : self.class.unauthenticated_redirect_path.to_s
            false
          end
			end
		end
	end
end