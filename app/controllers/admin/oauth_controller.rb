require 'base64'
class Admin::OauthController < AdminController
  
  def oauth2_redirect
    state = params[:state]
    error = params[:error]
    code = params[:code]
    if state == session[:state]
      client = oauth2_client
      client.authorization_code = code
      if resp = client.access_token!
        session[:refresh_token] = resp.refresh_token
        session[:access_token] = resp.access_token
        session[:realm_id] = params[:realmId]
        current_user.qb_access_token = resp.access_token
        current_user.qb_access_secret = resp.refresh_token
        current_user.qb_company_id = params[:realmId]
        current_user.qb_token_expires_at = 90.days.from_now.utc
        current_user.save
      else
        puts "Something went wrong. Try the process again"
      end
    else
      puts "Error: #{error}"
    end
  end
  
end