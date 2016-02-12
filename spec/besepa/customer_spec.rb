require 'helper'

describe Besepa::Customer do

  describe '#all' do
    before do
      stub_get('/customers').to_return(body: fixture('customers.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'returns a list of customers' do
      customers = Besepa::Customer.all
      expect(customers).to be_an Array
      expect(customers.first).to be_an Besepa::Customer
      expect(customers.size).to eq(1)
    end
  end

  describe '#find' do
    before do
      stub_get('/customers/cus12345').to_return(body: fixture('customer.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'returns a a customer' do
      customer = Besepa::Customer.find('cus12345')
      expect(customer).to be_an Besepa::Customer
      expect(customer.name).to eq("Pancho Villa SLU")
    end
  end

  describe '#search' do
    before do
      stub_get('/customers/search?field=group_id&value=foo').to_return(body: fixture('customers.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'returs a list of customers' do
      customers = Besepa::Customer.search(field: 'group_id', value: 'foo')
      expect(customers).to be_an Array
      expect(customers.first).to be_an Besepa::Customer
      expect(customers.size).to eq(1)
    end
  end

  describe '.save' do
    before do
      stub_get('/customers/cus12345').to_return(body: fixture('customer.json'), headers: {content_type: 'application/json; charset=utf-8'})
      stub_put('/customers/cus12345').to_return(body: fixture('customer.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'returns a a customer' do
      customer = Besepa::Customer.find('cus12345')
      customer.name = customer.name.reverse
      customer = customer.save
      expect(customer).to be_an Besepa::Customer
    end
  end

  describe '.destroy' do

    before do
      stub_get('/customers/cus12345').to_return(body: fixture('customer.json'), headers: {content_type: 'application/json; charset=utf-8'})
      stub_delete('/customers/cus12345').to_return(body: fixture('customer_removed.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'returns a a customer' do
      customer = Besepa::Customer.find('cus12345')
      customer.name = customer.name.reverse
      customer = customer.destroy
      expect(customer).to be_an Besepa::Customer
      expect(customer.status).to eq('REMOVED')
    end
  end

  describe "getting customer debits" do
    before do
      stub_get('/customers/cus12345/debits').to_return(body: fixture('customer_debits.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'returns a list of debits' do
      debits = Besepa::Customer.new(id: 'cus12345').debits
      expect(debits).to be_an Array
      expect(debits.first).to be_an Besepa::Debit
      expect(debits.size).to eq(1)
    end
  end

  describe "creating a debit for a customer" do
    describe "with valid data" do
      before do
        stub_post('/customers/cus12345/debits').to_return(body: fixture('customer_add_debit.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end

      it 'returns the new created debit' do
        debit = Besepa::Customer.new(id: 'cus12345').add_debit("man123", "ref123", "desc123", 1000, '2015-11-23')

        expect(debit).to be_an Besepa::Debit
      end
    end
  end

  describe "getting customer bank_accounts" do
    before do
      stub_get('/customers/cus12345/bank_accounts').to_return(body: fixture('customer_bank_accounts.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'returns a list of bank accounts' do
      bank_accounts = Besepa::Customer.new(id: 'cus12345').bank_accounts
      expect(bank_accounts).to be_an Array
      expect(bank_accounts.first).to be_an Besepa::BankAccount
      expect(bank_accounts.size).to eq(1)
    end
  end
end
