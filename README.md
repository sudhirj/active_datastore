# ActiveDatastore

With the release of the [Google Cloud Datastore API](https://developers.google.com/datastore/), it's finally possible to leverage the datastore in pretty much any stack. Since Google seems to be supporting NodeJS, Python and Java right of the bat, it makes sense to bridge the Ruby gap. 

ActiveDatastore is (eventually) meant to be comparable to [ActiveRecord](https://github.com/rails/rails/tree/master/activerecord) in terms of API, features and ease of use. It will rely heavily on [ActiveModel](https://github.com/rails/rails/tree/master/activemodel), but will continue to be framework agnostic and usable with or without [Rails](http://rubyonrails.org/).

## Current Status
I've built a wrapper over the GCD API (`ActiveDatastore::Dataset`) that's fully functional and can be used for pretty much all the examples given in the documentation. The wrapper's API is very similar to what you see in the NodeJS examples. 

Right now, ActiveDatastore is very much a work in progress. Please evaluate it before production use, and do remember that the API will undergo breaking changes until we hit v1.0.

## Installation

Add this line to your application's Gemfile:

    gem 'active_datastore'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_datastore

## Usage

Follow the instructions [here](https://developers.google.com/datastore/docs/activate#google_cloud_datastore_from_other_platforms) to get your **service account** (`AUTH_EMAIL`), **private key** (`AUTH_KEY`) and **dataset id** (`DATASET_ID`).

In your initializer (if you're on Rails you could create `config/initializers/datastore.rb`):
	
	require 'active_datastore'
	
	AUTH_EMAIL = "something@developer.gserviceaccount.com"
	AUTH_KEY = File.open("path/to/my/secret.key.p12").read
	DATASET_ID = "my-dataset"
	
	client = ActiveDatastore::Client.new AUTH_EMAIL, AUTH_KEY
	$dataset = ActiveDatastore::Dataset.new DATASET_ID, client

The initialization of the client seems be performance / network intensive, so it might make sense to do it once and hold the `$dataset` for the lifetime of the application. `ActiveDatastore::Dataset` is stateless and should support this.

To make calls to the datastore, use the methods documented on the [JSON API Reference](https://developers.google.com/datastore/docs/apis/v1beta1/datasets) (but remember use the underscore equivalent names.)

	start_response = $dataset.begin_transaction({
	  isolationLevel: "snapshot"
	})
	
	start_response.data.kind    # Should be "datastore#beginTransactionResponse"
	transaction_id = start_response.data.transaction

	rollback_response = $dataset.rollback({
	  transaction: transaction_id
	})
	
	rollback_response.data.kind    # Should be "datastore#rollbackResponse"  

Remeber that both the request body and the `response.data` are hashes with camel case keys, as shown in the [docs](https://developers.google.com/datastore/docs/apis/v1beta1/datasets/lookup#response). I know it's a little inconsistent that way, but an effort to deeply walk through each hash and convert keys will probably be more trouble than it's worth.


## Contributing

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. **WRITE GOOD AND CLEAR TESTS**. Do remember that this gem may be used in production to serve millions of requests. Bugs can be catastrophic. Also, I can't merge and maintain code I don't fully understand.
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
