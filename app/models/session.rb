class Session < TessituraResource
    attr_accessor :session_key, :user_name, :password, :order_id, :is_logged_in, :mode_of_sale_id, :source_id, :login_info, :cart_info, :is_guest
	def is_logged_in?; self.is_logged_in; end
	def is_guest?; self.is_guest; end
		
	self.types = {
		order_id: :integer,
		mode_of_sale_id: :integer,
		source_id: :integer,
		is_logged_in: :boolean,
		is_guest: :boolean,
		login_info: 'LoginInfo',
		cart_info: 'CartInfo'
	}
	
	def constituent
		@constituent ||= Constituent.find(login_info.constituent_id) rescue nil
	end
    
    
	class << self
	    def group_name
			"Web"
		end
		
		def class_name
			"Session"
		end
		
        def new_session_key(remote_ip='')
            resp = TessituraClient.post("/Web/Session", {ip_address: remote_ip, business_unit_id: 1})
            resp[:session_key]
        end
        
        def logout(session_key='')
            resp = TessituraClient.post("/Web/Session/#{session_key}/Logout", {}) if session_key.present?
            resp
        end
        
        def login(user_name, password, options = {})
            session_key = options[:session_key] || new_session_key(option[:remote_ip] || "")
            validate_resp = TessituraClient.post("/Security/ValidateWebLogin", {login_type_id: 1, login_name: user_name, password: password}) rescue {is_authenticated: false}
            if validate_resp[:is_authenticated]
            	parms = {login_type_id: 1, user_name: user_name, password: password}
	            parms[:promotion_code] = options[:source_code] if options[:source_code].present?
	            resp = TessituraClient.post("/Web/Session/#{session_key}/Login", parms)
	            session = self.from_data(resp.to_json)
	            session.session_key = session_key
	            return session
	        end
	        return nil
        end
        
        def forgot_password(email, options = {})
            session_key = options[:session_key] || new_session_key(option[:remote_ip] || "")
            resp = TessituraClient.post("/Web/Session/#{session_key}/Login/SendCredentials", {email_address: email, login_type_id: 1}) if session_key.present?
            resp
        end
    end
end