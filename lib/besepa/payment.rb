module Besepa
  class Payment < Besepa::Resource

    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Search

    FIELDS = [:id, :reference, :amount, :currency, :status, :send_at, :sent_at, :description, :metadata, :created_at]

    ALLOWED_NILS = [:collect_at]

    FIELDS.each do |f|
      attr_accessor f
    end

    attr_accessor :customer, :debtor_bank_account, :creditor_bank_account

    def to_hash
      values = {}
      self.class::FIELDS.each do |key|
        values[key] = self.send("#{key.to_s}")
      end
      values[:debtor_bank_account] = debtor_bank_account.to_hash if debtor_bank_account
      values[:creditor_bank_account] = creditor_bank_account.to_hash if creditor_bank_account
      values[:customer] = customer.to_hash if customer
      values
    end

    def allowed_nils
      ALLOWED_NILS
    end

    protected

    def self.query_params(filters = {})
      filters = filters.dup
      filters.delete(:customer_id)
      filters
    end

    def self.api_path(filters={})
      customer_id = filters[:customer_id]
      if customer_id
        "#{Customer.api_path}/#{CGI.escape(customer_id)}/payments"
      else
        '/payments'
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
      self.creditor_bank_account = Besepa::BusinessAccount.new(attrs['creditor_bank_account']) if attrs['creditor_bank_account']
      self.customer = Besepa::Customer.new(attrs['customer']) if attrs['customer']
      self
    end
  end
end
