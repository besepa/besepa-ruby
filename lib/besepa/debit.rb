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

    protected 
    
      def self.api_path(filters={})
        "#{Customer.api_path}/#{CGI.escape(filters[:customer_id])}/debits"
      end

      def api_path(filters={})
        "#{Customer.api_path}/#{CGI.escape(filters[:customer_id])}/debits/#{CGI.escape(id)}"
      end

  end
end