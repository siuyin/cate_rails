
Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = ENV['BTREE_MERCHANT_ID']
Braintree::Configuration.public_key = ENV['BTREE_PUBLIC_KEY'] 
Braintree::Configuration.private_key = ENV['BTREE_PRIVATE_KEY'] 

