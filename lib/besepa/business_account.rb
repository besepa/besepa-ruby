module Besepa

  class BusinessAccount < Besepa::Resource
    
    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Update
#    include Besepa::ApiCalls::Destroy
            
    FIELDS = [:id, :iban, :bic, :bank_name, :status, :default, :core_enabled, :core_suffix, :b2b_enabled, :b2b_suffix, :created_at, :authorization]  
    
    FIELDS.each do |f|
      attr_accessor f
    end   
        
    def self.klass_name
      "bank_account"
    end

    def set_as_default
      response = put "#{api_path}/set_as_default"
      process_attributes(response['response'])
      self
    end
    
    def activation_request
      response = put "#{api_path}/activation_request"
      process_attributes(response['response'])
      self
    end
    
    protected 
    
      def self.api_path(filters={})
        "/account/bank_accounts"
      end

      def api_path(filters={})
        "/account/bank_accounts/#{CGI.escape(id)}"
      end

  end
end
