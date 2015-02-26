module Besepa

  class Subscription < Besepa::Resource
    
    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Destroy
        
    FIELDS = [:id, :reference, :status, :metadata]
    
    FIELDS.each do |f|
      attr_accessor f
    end    
    
    def self.api_path(filters={})
      "#{Customer.api_path}/#{CGI.escape(filters[:customer_id])}/subscriptions"
    end

    def api_path(filters={})
      "#{Customer.api_path}/#{CGI.escape(filters[:customer_id])}/subscriptions/#{CGI.escape(id)}"
    end


  end
end