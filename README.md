# Besepa::Ruby

A Ruby gem to Besepa.com's API.

## Installation

Add this line to your application's Gemfile:

    gem 'besepa'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install besepa
    
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
**Add new customer

```ruby
Besepa::Customer.new(id: customer_id)
#=> <Besepa::Customer:0x0000 @id=nil, @name=nil, @taxid=nil, @reference=nil, @contact_name=nil, @contact_email=nil, @contact_phone=nil, @contact_language=nil, @address_street=nil, @address_city=nil, @address_postalcode=nil, @address_state=nil, @address_country=nil, @status=nil, @created_at=nil>
```
Create empty object but do not save it.

or
```ruby
Besepa::Customer.create(name: 'name')
#=> <Besepa::Customer:...,@name="name",...>
```

**Get all customers**

```ruby
Besepa::Customer.all
#=>=> [#<Besepa::Customer:...>, #<Besepa::Customer:...>]
```

**Get one customer's information**

```ruby
Besepa::Customer.find( customer_id  )
#=> #<Besepa::Customer:...,@id= customer_id>
```

**Update customer**

```ruby
c = Besepa::Customer.find( customer_id  )
#=>#<Besepa::Customer:...>
c.name = 'New name'
#=> "New name"
c.save
#=>=> #<Besepa::Customer:..., @name= "New name",...>
```

**Remove customer**

```ruby
c = Besepa::Customer.find( customer_id  )
#=>#<Besepa::Customer:...>
c.destroy #customer's state is change to 'REMOVED'
#=> #<Besepa::Customer:..., @status="REMOVED",...>
```

Note all subscriptions, upcoming debits and mandates for this customer will be cancelled


**Get customer's bank accounts**

```ruby
Besepa::Customer.find( customer_id  ).bank_accounts
# => [#<Besepa::BankAccount:..., #<Besepa::BankAccount:...>]
```
The result is a array of Besepa::BankAccount

In case you don't have a Customer yet, just create one Customer object with it's id.
```ruby
Besepa::Customer.new( id: customer_id  ).bank_accounts
```

**Add a bank account to a customer**

```ruby
Besepa::Customer.new( id: customer_id  ).add_bank_account(iban, bic, bank_name)
# => #<Besepa::BankAccount:...>

```
bank_name is optional.

**Update bank account**

```ruby
b = Besepa::Customer.find(customer_id).bank_accounts.detect{|b|  b.id == bank_account_id }
# => #<Besepa::BankAccount:...>
b.replace(iban, bic, bank_name)
#=> #<Besepa::BankAccount:... >
```
bank_name is optional. 
Other possible arguments are signature_type, phone_number and redirect_after_signature


**Get customer's debits**

```ruby
Besepa::Customer.new( id: customer_id  ).debits
#=>=> [#<Besepa::Debit:...>, #<Besepa::Debit:...>]
```

**Create a debit for a customer**

```ruby
Besepa::Customer.new(id: customer_id  ).add_debit(bank_account_id, reference, description, amount, collect_at, creditor_account_id, metadata)
#=> #<Besepa::Debit:...>
```
Amount is with two decimals, without separation character (1000 == 10.00)
Metadata can be a hash that we will store associated to this debit. creditor_account_id is optional, if none passed, we will use account's default one. 
The bank_account status should be 'ACTIVE'

**Get customer's subscriptions**

```ruby
Besepa::Customer.new( id: customer_id  ).subscriptions
#=> [#<Besepa::Subscription:...>, #<Besepa::Subscription:...>]>
```

**Add customer'subscription**

```ruby
Besepa::Customer.find(customer_id).add_subscription(starts_at, product_code, bank_account_id)
#=> #<Besepa::Subscription:...>
```
Remmember that the bank account status should be 'ACTIVE'

**Get customer's groups**
List of groups this customer belongs to
```ruby
Besepa::Customer.find(customer_id).groups
#=>[#<Besepa::Group:...>, #<Besepa::Group:...>]
```

**Add customer to group**

```ruby
Besepa::Customer.find(customer_id).add_to_group(group_id)
# => true
```

**Remove customer from the group**

```ruby
Besepa::Customer.find(customer_id).remove_from_group(group_id)
# => true
```




## Supported Ruby Versions

Right now, this gem has been tested with Ruby 2 only. More coming.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Copyright

Copyright (c) 2015 Besepa Technologies S.L.. See LICENSE for details.
