module Besepa

  class Group < Besepa::Resource
        
    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Update
    include Besepa::ApiCalls::Destroy
        
    FIELDS = [:id, :name, :reference]
    
    FIELDS.each do |f|
      attr_accessor f
    end    

  end
end