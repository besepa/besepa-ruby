module Besepa

  class Group < Besepa::Resource
        
    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Update
    include Besepa::ApiCalls::Destroy
        
    FIELDS = [:id, :name, :reference, :created_at]
    
    FIELDS.each do |f|
      attr_accessor f
    end    

    protected
    
      def self.api_path(filters={})
        if filters[:customer_id]
          "#{Customer.api_path}/#{CGI.escape(filters[:customer_id])}/groups"
        else
          "/groups"
        end
      end
      
  end
end