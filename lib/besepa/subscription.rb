module Besepa
  class Subscription < Besepa::Resource

    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Search
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Destroy

    FIELDS = [:id, :last_debit, :next_debit, :status, :metadata, :starts_at, :renew_at, :created_at, :setup_fee, :customer_code]

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
      customer_id = filters[:customer_id]
      if customer_id
        "#{Customer.api_path}/#{CGI.escape(customer_id)}/subscriptions"
      else
        "/subscriptions"
      end
    end

    def api_path(filters={})
      "#{self.class.api_path(filters)}/#{CGI.escape(id)}"
    end

    def process_attributes(attrs)
      self.class::FIELDS.each do |key|
        self.send("#{key.to_s}=", attrs[key.to_s] || attrs[key.to_sym])
      end
      self.debtor_bank_account = Besepa::BankAccount.new(attrs['debtor_bank_account']) if attrs['debtor_bank_account']
      self.product = Besepa::Product.new(attrs['product']) if attrs['product']
      self.customer = Besepa::Customer.new(attrs['customer']) if attrs['customer']
      process_activities(attrs)
      self
    end
  end
end
