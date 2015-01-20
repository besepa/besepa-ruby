# Besepa::Ruby

A Ruby gem to Besepa.com's API.

## Installation

Add this line to your application's Gemfile:

    gem 'besepa-ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install besepa-ruby
    
## Documentation

http://apidocs.besepa.com


## Configuration

```ruby
Besepa.configure do |config|
  config.api_key = API_KEY 
  config.endpoint = API_END_POINT
end
```

By default, this gem points to Besepa's sandbox (https://sandbox.besepa.com). If you want to point to Besepa's production environment, use https://api.besepa.com as endpoint.

Remeber that API_KEY changes from one environment to the other.

## Usage

**Get all customers**

```ruby
Besepa::Customer.all
```

**Get one customer's information**

```ruby
Besepa::Customer.find( customer_id  )
```

**Get customer's bank accounts**

```ruby
Besepa::Customer.find( customer_id  ).bank_accounts
```

In case you don't have a Customer yet, just create one Customer object with it's id.
```ruby
Besepa::Customer.new( id: customer_id  ).bank_accounts
```

**Get customer's subscriptions**

```ruby
Besepa::Customer.new( id: customer_id  ).subscriptions
```

**Get customer's debits**

```ruby
Besepa::Customer.new( id: customer_id  ).debits
```

**Add a bank account to a customer**

```ruby
Besepa::Customer.new( id: customer_id  ).add_bank_account(iban, bic, bank_name)

```
bank_name is optional.

**Create a debit for a customer**

```ruby
Besepa::Customer.new( id: customer_id  ).add_debit(mandate_id, reference, description, amount, collect_at, creditor_account_id, metadata)
```

Amount is with two decimals, without separation character (1000 == 10.00)
Metadata can be a hash that we will store associated to this debit. creditor_account_id is optional, if none passed, we will use account's default one. 









## Supported Ruby Versions

Right now, this gem has been testing with Ruby 2 only. More coming.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Copyright

Copyright (c) 2015 Besepa Technologies S.L.. See LICENSE for details.