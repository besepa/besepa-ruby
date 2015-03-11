module Besepa

  class Webhook < Besepa::Resource
        
    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Destroy
        
    FIELDS = [:id, :url, :status, :push_count, :ok_count, :success_rate]  
    
    FIELDS.each do |f|
      attr_accessor f
    end    

  end
end