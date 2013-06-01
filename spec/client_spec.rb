require 'spec_helper'
require 'pry'
describe ActiveDatastore::Client do

	let (:client) { ActiveDatastore::Client.new AUTH_EMAIL, AUTH_KEY }

  it 'should connect to the GCD, given credentials' do
  	client.valid?.should be_true
  end

  it 'should discover the datastore api' do
  	client.api.lookup.generate_uri(datasetId: 'abc').to_s.should == "https://www.googleapis.com/datastore/v1beta1/datasets/abc/lookup"
  end

  it 'should execute calls made using the google client' do
  	response = client.execute method: :begin_transaction, body: {"isolationLevel" => "snapshot"}, params: {datasetId: 'active-datastore-test'}
  	response.data.transaction.should_not be_nil
  	response.data.kind.should == 'datastore#beginTransactionResponse'
  end
end
