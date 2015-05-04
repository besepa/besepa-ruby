module Besepa

  class BankAccount < Besepa::Resource
    
    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Update
    include Besepa::ApiCalls::Destroy
            
    FIELDS = [:id, :iban, :bic, :bank_name, :status, :customer_id, :created_at]  
    
    FIELDS.each do |f|
      attr_accessor f
    end   

    attr_accessor :mandate
        
    def self.klass_name
      "bank_account"
    end

    def set_as_default
      response = put "/#{api_path({customer_id: customer_id})}/set_as_default"
      process_attributes(response['response'])
      self
    end
    
    def generate_signature_request
      response = put "/#{api_path({customer_id: customer_id})}/generate_signature_request"
      process_attributes(response['response'])
      self
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
        "#{Customer.api_path}/#{CGI.escape(filters[:customer_id]||customer_id)}/bank_accounts/#{CGI.escape(id)}"
      end
    
      def process_attributes(attrs)
        self.class::FIELDS.each do |key|
          self.send("#{key.to_s}=", attrs[key.to_s] || attrs[key.to_sym])
        end
        self.mandate = Besepa::Mandate.new(attrs['mandate']) if attrs['mandate']
        process_activities(attrs)
        self
      end

  end
end