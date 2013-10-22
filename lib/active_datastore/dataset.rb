module ActiveDatastore
	class Dataset
		METHODS = [:allocate_ids, :begin_transaction, :commit, :lookup, :rollback, :run_query]
		def initialize dataset_id, client
			@client = client
			@dataset_id = dataset_id
		end

		METHODS.each do |method|
			define_method method do |body={}|
				@client.execute method: method, body: body, params: {datasetId: @dataset_id}
			end
		end
	end
end