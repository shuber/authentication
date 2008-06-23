module Huberry
	module Authentication
		module ControllerMethods			
			def self.extended(base)
				base.class_eval do
					include InstanceMethods

					cattr_accessor :authentication_model, :unauthenticated_message, :unauthenticated_redirect_path
					self.authentication_model = 'User'
					self.unauthenticated_message = 'Login to continue'
					self.unauthenticated_redirect_path = '/'

					attr_accessor :current_user
					helper_method :current_user, :logged_in?
				end
			end
			
			module InstanceMethods
				protected
				
					def authentication_required
            unauthenticated unless logged_in?
          end

          def find_current_user(force_query = false)
						if @queried_for_current_user.nil? || force_query
							@queried_for_current_user = true
							self.current_user = self.class.authentication_model.to_s.constantize.find(session[:user_id]) rescue nil
						end
						self.current_user
          end
					
          def logged_in?
            find_current_user if self.current_user.nil?
						if self.current_user.nil?
							block_given? ? nil : false
						else
							block_given? ? yield : true
						end
          end
					
          def login(user)
            self.current_user = user
            session[:user_id] = user.id
          end
					
          def logout
            self.current_user = nil
            session[:user_id] = nil
          end
					
          def unauthenticated
						session[:return_to] = request.request_uri
            flash[:error] = self.class.unauthenticated_message.to_s
            redirect_to respond_to?(self.class.unauthenticated_redirect_path) ? send(self.class.unauthenticated_redirect_path) : self.class.unauthenticated_redirect_path.to_s
            false
          end
			end
		end
	end
end