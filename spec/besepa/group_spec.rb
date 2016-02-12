require 'helper'

describe Besepa::Group do

  describe '#customers' do
    before do
      @group = Besepa::Group.new(id: 42)
      stub_get('/customers/search?field=group_id&value=42').to_return(body: fixture('customers.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'returns a list of customers' do
      customers = @group.customers
      expect(customers).to be_an Array
      expect(customers.first).to be_an Besepa::Customer
      expect(customers.size).to eq(1)
    end
  end
end
