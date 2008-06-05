module Huberry
	module Authentication
		module ControllerMethods
			def self.included(base)
				base.send :include, InstanceMethods
				base.class_eval do
					cattr_accessor :unauthenticated_message, :unauthenticated_redirect_path
					self.unauthenticated_message = 'Login to continue'
					self.unauthenticated_redirect_path = :new_session_path

					attr_accessor :current_user
					helper_method :current_user, :logged_in?
				end
			end
			
			module InstanceMethods
				protected

          def find_current_user
            self.current_user = User.find_by_id(session[:user_id]) || false
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
            session.delete :user_id
          end
					
          def unauthenticated
            flash[:error] = self.class.unauthenticated_message.to_s
            redirect_to respond_to?(self.class.unauthenticated_redirect_path) ? send(self.class.unauthenticated_redirect_path) : '/'
            false
          end
			end
		end
	end
end