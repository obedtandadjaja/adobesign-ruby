require 'clients/adobe_sign/request'

module AdobeSign
  class Authentication
    def self.new_access_token(client_id, client_secret, refresh_token)
      body_params = {
        grant_type: 'refresh_token',
        client_id: client_id,
        client_secret: client_secret,
        refresh_token: refresh_token
      }
      response = AdobeSign::Request.refresh_access_token(body_params)
      response.fetch('access_token')
    end
  end
end
