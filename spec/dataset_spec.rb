require 'spec_helper'

describe ActiveDatastore::Dataset do
  let (:client) { ActiveDatastore::Client.new AUTH_EMAIL, AUTH_KEY }
  let (:dataset) { ActiveDatastore::Dataset.new 'active-datastore-test', client }

  it "should have all the datastore api methods" do
  	discovered_methods = client.api.discovered_methods.map(&:id).map{|n| n.split('.')[2]}.map(&:underscore).map(&:to_sym)
  	ActiveDatastore::Dataset::METHODS.sort.should == discovered_methods.sort

    ActiveDatastore::Dataset::METHODS.each do |method|
      dataset.respond_to?(method).should be_true
    end
  end

  it "should execute corresponding methods on the client with the given parameters, always including the dataset id" do
  	ActiveDatastore::Dataset::METHODS.each do |method|
      client.should_receive(:execute).with(method: method, body: {abc: 42}, params: {datasetId: 'active-datastore-test'} )
  		dataset.send(method, {abc: 42})
    end
  end

  context "transactions" do
  	it 'should start and rollback a transaction' do
  		start_response = dataset.begin_transaction
  		start_response.data.kind.should == "datastore#beginTransactionResponse"
  		start_response.data.transaction.should_not be_nil

  		rollback_response = dataset.rollback({transaction: start_response.data.transaction})
  		rollback_response.data.kind.should == "datastore#rollbackResponse"
  	end
  end

end
