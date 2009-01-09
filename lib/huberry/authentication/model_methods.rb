require 'digest/sha2'

module Huberry
  module Authentication
    module ModelMethods
      def uses_authentication(options = {})
        extend ClassMethods
        include InstanceMethods
        
        cattr_accessor :authentication_options
        self.authentication_options = {
          :hashed_password_field => :hashed_password, 
          :login_field => :email, 
          :password_field => :password, 
          :salt_field => :salt 
        }.merge(options)
        
        attr_accessor self.authentication_options[:password_field], "#{self.authentication_options[:password_field]}_confirmation".to_sym
        
        validates_presence_of self.authentication_options[:login_field]
        validates_presence_of self.authentication_options[:password_field], :if => :password_required?
        validates_confirmation_of self.authentication_options[:password_field], :if => :password_required?
        
        before_save :hash_password
        
        alias_method_chain :reload, :authentication
      end
    end
    
    module ClassMethods
      def authenticate(login, password)
        user = send("find_by_#{self.authentication_options[:login_field]}", login)
        user && user.authenticated?(password) ? user : false
      end
      
      def digest(str)
        Digest::SHA256.hexdigest(str.to_s)
      end
    end
    
    module InstanceMethods
      def authenticated?(password)
        send(self.class.authentication_options[:hashed_password_field]) == self.class.digest(password.to_s + send(self.class.authentication_options[:salt_field]).to_s)
      end
      
      def password_changed?
        !!@password_changed
      end
      
      def reload_with_authentication(*args)
        reload_without_authentication(*args)
        @password_changed = false
      end
      
      def reset_password(new_password = nil)
        new_password = generate_salt[0..7] if new_password.blank?
        send("#{self.class.authentication_options[:salt_field]}=", nil)
        send("#{self.class.authentication_options[:password_field]}=", new_password)
        send("#{self.class.authentication_options[:password_field]}_confirmation=", new_password)
        @password_changed = true
      end
      
      def reset_password!(new_password = nil)
        reset_password(new_password)
        save
      end
      
      protected
        
        def generate_salt
          self.class.digest("--#{Time.now}--#{rand}--")
        end
        
        def hash_password
          if password_changed? || password_required?
            send("#{self.class.authentication_options[:salt_field]}=", generate_salt) if send("#{self.class.authentication_options[:salt_field]}").blank?
            send("#{self.class.authentication_options[:hashed_password_field]}=", self.class.digest(send(self.class.authentication_options[:password_field]).to_s + send(self.class.authentication_options[:salt_field]).to_s))
          end
        end
        
        def password_required?
          send(self.class.authentication_options[:hashed_password_field]).blank? || !send(self.class.authentication_options[:password_field]).blank?
        end
    end
  end
end