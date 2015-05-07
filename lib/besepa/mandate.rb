module Besepa

  class Mandate < Besepa::Resource
    
    include Besepa::ApiCalls::List
        
    FIELDS = [:id, :signed_at, :status, :description, :signature_type, 
              :mandate_type, :reference, :url, :used, :phone_number, :scheme,
              :signature_url, :download_url, :created_at, :redirect_after_signature]
    
    FIELDS.each do |f|
      attr_accessor f
    end    
    
    def api_path
      "/customers/#{self.customer_id}/#{self.class.api_path}"
    end

  end
end