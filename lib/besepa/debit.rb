module Besepa

  class Debit < Besepa::Resource
    
    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Update
    include Besepa::ApiCalls::Destroy
        
    FIELDS = [:id, :reference, :amount, :currency, :status, 
              :collect_at, :sent_at, :description, :metadata, 
              :error_code, :platform_error_code]
    
    FIELDS.each do |f|
      attr_accessor f
    end

    attr_accessor :debtor_bank_account, :creditor_bank_account, :customer

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

    protected 
    
      def self.api_path(filters={})
        if filters[:customer_id]
          "#{Customer.api_path}/#{CGI.escape(filters[:customer_id])}/debits"
        else
          "#{Group.api_path}/#{CGI.escape(filters[:group_id])}/debits"
        end
      end

      def api_path(filters={})
        if filters[:customer_id]
        "#{Customer.api_path}/#{CGI.escape(filters[:customer_id])}/debits/#{CGI.escape(id)}"
        else
          "#{Group.api_path}/#{CGI.escape(filters[:group_id])}/debits/#{CGI.escape(id)}"
        end
      end

      def process_attributes(attrs)
        self.class::FIELDS.each do |key|
          self.send("#{key.to_s}=", attrs[key.to_s] || attrs[key.to_sym])
        end
        self.debtor_bank_account = Besepa::BankAccount.new(attrs['debtor_bank_account']) if attrs['debtor_bank_account']
        self.creditor_bank_account = Besepa::BankAccount.new(attrs['creditor_bank_account']) if attrs['creditor_bank_account']
        self.customer = Besepa::Customer.new(attrs['customer']) if attrs['customer']
        self
      end
  end
end