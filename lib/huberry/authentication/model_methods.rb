require 'digest/sha2'

module Huberry
	module Authentication
		module ModelMethods
			def acts_as_authenticated(options = {})
				extend ClassMethods
				include InstanceMethods
				
				cattr_accessor :login_field
				self.login_field = options[:login_field] || :email
				
				attr_accessor :password, :password_confirmation
	
				validates_presence_of self.login_field
  			validates_presence_of :password, :if => :password_required?
  			validates_confirmation_of :password, :if => :password_required?
	
  			before_save :hash_password
			end
		end
		
		module ClassMethods
			def authenticate(login, password)
				user = send("find_by_#{self.login_field}", login)
        user && user.authenticated?(password) ? user : false
      end

      def digest(str)
        Digest::SHA256.hexdigest(str.to_s)
      end
		end
		
		module InstanceMethods
			def authenticated?(password)
				self.hashed_password == self.class.digest(password.to_s + self.salt.to_s)
      end

			def password_changed?
				!!@password_changed
			end

      def reset_password(new_password = nil)
        new_password = generate_salt[0..7] if new_password.blank?
				self.salt = nil
				self.password = new_password
				self.password_confirmation = new_password
				@password_changed = true
      end

			def reset_password!(new_password = nil)
				reset_password(new_password)
				save
			end

      private

        def generate_salt
          self.class.digest("--#{Time.now}--#{rand}--")
        end

        def hash_password
					self.salt = generate_salt if self.salt.blank?
					self.hashed_password = self.class.digest(self.password.to_s + self.salt.to_s)
        end
  
        def password_required?
					self.hashed_password.blank? || !self.password.blank?
        end
		end
	end
end