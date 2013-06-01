require 'rubygems'
require 'bundler/setup'

require 'active_datastore'

credentials = YAML.load File.open 'spec/credentials.yml'

AUTH_EMAIL = credentials["EMAIL"]
AUTH_KEY = File.open(credentials["KEY_PATH"]).read

RSpec.configure do |config|

end
