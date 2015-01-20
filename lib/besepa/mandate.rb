module Besepa

  class Mandate < Besepa::Resource
    
    include Besepa::ApiCalls::List
        
    FIELDS = [:id, :created_at, :signed_at, :status, :description, :signature_type, :mandate_type, :customer_id, :product_id, :url]
    
    FIELDS.each do |f|
      attr_accessor f
    end    
    
    def api_path
      "/customers/#{self.customer_id}/#{self.class.api_path}"
    end

  end
end