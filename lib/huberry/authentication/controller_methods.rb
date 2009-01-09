module Huberry
  module Authentication
    module ControllerMethods      
      def self.extended(base)
        base.class_eval do
          include InstanceMethods
          
          cattr_accessor :authentication_options
          self.authentication_options = {
            :flash_type => :error, 
            :model => 'User', 
            :message => 'Login to continue', 
            :redirect_to => '/' 
          }
          
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
              self.current_user = self.class.authentication_options[:model].to_s.constantize.find(session[authentication_session_field]) rescue nil
            end
            self.current_user
          end
          
          def logged_in?
            !find_current_user.nil?
          end
          
          def login(user)
            self.current_user = user
            session[authentication_session_field] = user.id
          end
          
          def logout
            self.current_user = nil
            session[authentication_session_field] = nil
          end
          
          def authentication_session_field
            self.class.authentication_options[:session_field] || "#{self.class.authentication_options[:model].to_s.underscore}_id".to_sym
          end
          
          def unauthenticated
            session[:return_to] = request.request_uri
            flash[self.class.authentication_options[:flash_type]] = self.class.authentication_options[:message] if self.class.authentication_options[:message]
            redirect_to respond_to?(self.class.authentication_options[:redirect_to]) ? send(self.class.authentication_options[:redirect_to]) : self.class.authentication_options[:redirect_to].to_s
          end
      end
    end
  end
end