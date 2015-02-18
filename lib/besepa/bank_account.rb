module Besepa

  class BankAccount < Besepa::Resource
    
    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Destroy
            
    FIELDS = [:id, :iban, :bic, :bank_name, :status, :customer_id]  
    
    FIELDS.each do |f|
      attr_accessor f
    end   

    attr_accessor :mandate
        
    def self.klass_name
      "bank_account"
    end
    
    def to_hash
      values = {}
      self.class::FIELDS.each do |key|
        values[key] = self.send("#{key.to_s}")
      end
      values[:mandate] = mandate.to_hash if mandate
      values
    end
    
    protected 
    
      def self.api_path(filters={})
        "#{Customer.api_path}/#{CGI.escape(filters[:customer_id])}/bank_accounts"
      end

      def api_path(filters={})
        "#{Customer.api_path}/#{CGI.escape(filters[:customer_id])}/bank_accounts"
      end
    
      def process_attributes(attrs)
        self.class::FIELDS.each do |key|
          self.send("#{key.to_s}=", attrs[key.to_s])
        end
        self.mandate = Besepa::Mandate.new(attrs['mandate']) if attrs['mandate']
        self
      end

  end
end