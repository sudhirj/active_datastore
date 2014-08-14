require 'google/api_client'

module ActiveDatastore
  class Client
    def initialize email, secret
      @client = Google::APIClient.new(application_name: 'ActiveDatastore', application_version: ActiveDatastore::VERSION)
      begin
        key = Google::APIClient::KeyUtils.load_from_pkcs12(secret, 'notasecret')
      rescue => ex
        if ex.message.include?("Invalid keyfile")
          # then try pem
          key = Google::APIClient::KeyUtils.load_from_pem(secret, 'notasecret')
        end
      end

      service_account = Google::APIClient::JWTAsserter.new(
        email,
        ['https://www.googleapis.com/auth/datastore', 'https://www.googleapis.com/auth/userinfo.email'],
      	key)
      @client.authorization = service_account.authorize

    end

    def valid?
    	not @client.authorization.expired?
    end

    def api
    	@api ||= @client.discovered_api('datastore', 'v1beta2').datasets
    end

    def execute opts
    	@client.execute({
    		api_method: api.send(opts[:method]),
    		body_object: opts[:body],
    		parameters: opts[:params]
    	})
    end
  end
end
