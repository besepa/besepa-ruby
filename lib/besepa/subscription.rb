module Besepa

  class Subscription < Besepa::Resource
    
    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Destroy
        
    FIELDS = [:id, :reference, :status, :metadata]
    
    FIELDS.each do |f|
      attr_accessor f
    end
    
    attr_accessor :debtor_bank_account, :product, :customer    
    
    def to_hash
      values = {}
      self.class::FIELDS.each do |key|
        values[key] = self.send("#{key.to_s}")
      end
      values[:debtor_bank_account] = debtor_bank_account.to_hash if debtor_bank_account
      values[:product] = product.to_hash if product
      values[:customer] = customer.to_hash if customer
      values
    end
    
    def self.api_path(filters={})
      "#{Customer.api_path}/#{CGI.escape(filters[:customer_id])}/subscriptions"
    end

    def api_path(filters={})
      "#{Customer.api_path}/#{CGI.escape(filters[:customer_id])}/subscriptions/#{CGI.escape(id)}"
    end
    
    def process_attributes(attrs)
      self.class::FIELDS.each do |key|
        self.send("#{key.to_s}=", attrs[key.to_s] || attrs[key.to_sym])
      end
      self.debtor_bank_account = Besepa::BankAccount.new(attrs['debtor_bank_account']) if attrs['debtor_bank_account']
      self.product = Besepa::Product.new(attrs['product']) if attrs['product']
      self.customer = Besepa::Customer.new(attrs['customer']) if attrs['customer']
      self
    end


  end
end