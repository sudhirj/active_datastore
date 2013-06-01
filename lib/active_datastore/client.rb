require 'google/api_client'

module ActiveDatastore
  class Client
    def initialize email, secret
      @client = Google::APIClient.new
      key = Google::APIClient::KeyUtils.load_from_pkcs12(secret, 'notasecret')
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
    	@api ||= @client.discovered_api('datastore', 'v1beta1').datasets
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
