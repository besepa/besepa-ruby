require 'helper'

describe Besepa::Subscription do

  describe '#all' do
    it 'without customer' do
      stub_get('/subscriptions?page=1').to_return(body: fixture('collection.json'), headers: {content_type: 'application/json; charset=utf-8'})

      subscriptions = Besepa::Subscription.all(page: 1)
      expect(subscriptions).to respond_to(:each)
      expect(subscriptions.first).to be_an Besepa::Subscription
      expect(subscriptions.size).to eq(1)
      expect(subscriptions.per_page).to eq(50)
      expect(subscriptions.current_page).to eq(1)
      expect(subscriptions.total).to eq(1)
      expect(subscriptions.pages).to eq(1)
    end

    it 'with customer' do
      stub_get('/customers/bar/subscriptions?page=1').to_return(body: fixture('collection.json'), headers: {content_type: 'application/json; charset=utf-8'})

      subscriptions = Besepa::Subscription.all(page: 1, customer_id: 'bar')
      expect(subscriptions).to respond_to(:each)
      expect(subscriptions.first).to be_an Besepa::Subscription
      expect(subscriptions.size).to eq(1)
      expect(subscriptions.per_page).to eq(50)
      expect(subscriptions.current_page).to eq(1)
      expect(subscriptions.total).to eq(1)
      expect(subscriptions.pages).to eq(1)
    end
  end

  describe '#find' do
    it 'without customer' do
      stub_get('/subscriptions/1').to_return(body: fixture('resource.json'), headers: {content_type: 'application/json; charset=utf-8'})

      subscription = Besepa::Subscription.find('1')
      expect(subscription).to be_an Besepa::Subscription
    end

    it 'with customer' do
      stub_get('/customers/bar/subscriptions/1').to_return(body: fixture('resource.json'), headers: {content_type: 'application/json; charset=utf-8'})

      subscription = Besepa::Subscription.find('1', customer_id: 'bar')
      expect(subscription).to be_an Besepa::Subscription
    end
  end

  describe '#search' do
    before do
      stub_get('/subscriptions/search?field=product_id&value=foo&page=1').to_return(body: fixture('collection.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'returs a list of customers' do
      customers = Besepa::Subscription.search(field: 'product_id', value: 'foo', page: 1)
      expect(customers).to respond_to(:each)
      expect(customers.first).to be_an Besepa::Subscription
      expect(customers.size).to eq(1)
      expect(customers.per_page).to eq(50)
      expect(customers.current_page).to eq(1)
      expect(customers.total).to eq(1)
      expect(customers.pages).to eq(1)
    end
  end

  describe '#update' do
    it 'posts resource to API' do
      stub_get('/subscriptions/res12345').to_return(body: fixture('resource.json'), headers: {content_type: 'application/json; charset=utf-8'})
      stub_put('/subscriptions/res12345').to_return(body: fixture('resource.json'), headers: {content_type: 'application/json; charset=utf-8'})

      subscription = Besepa::Subscription.find('res12345')

      subscription.save

      expect(subscription).to be_an Besepa::Subscription
    end
  end
end
