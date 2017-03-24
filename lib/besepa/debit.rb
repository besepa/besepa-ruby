module Besepa
  class Debit < Besepa::Resource

    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Search
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Update
    include Besepa::ApiCalls::Destroy

    FIELDS = [:id, :reference, :amount, :currency, :status,
              :collect_at, :sent_at, :description, :metadata,
              :error_code, :platform_error_code, :created_at, :rejected_at,
              :debtor_bank_account_id, :creditor_bank_account_id]

    ALLOWED_NILS = [:collect_at]

    FIELDS.each do |f|
      attr_accessor f
    end

    attr_accessor :debtor_bank_account, :creditor_bank_account, :customer, :remittance, :subscription

    def to_hash
      values = {}
      self.class::FIELDS.each do |key|
        values[key] = self.send("#{key.to_s}")
      end
      values[:debtor_bank_account] = debtor_bank_account.to_hash if debtor_bank_account
      values[:creditor_bank_account] = creditor_bank_account.to_hash if creditor_bank_account
      values[:customer] = customer.to_hash if customer
      values[:remittance] = remittance.to_hash if remittance
      values[:subscription] = subscription.to_hash if subscription
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
        "#{Customer.api_path}/#{CGI.escape(customer_id)}/debits"
      else
        '/debits'
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
      self.remittance = Besepa::Remittance.new(attrs['remittance']) if attrs['remittance']
      self.subscription = Besepa::Subscription.new(attrs['subscription']) if attrs['subscription']
      process_activities(attrs)
      self
    end
  end
end
