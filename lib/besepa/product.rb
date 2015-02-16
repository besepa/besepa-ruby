module Besepa

  class Product < Besepa::Resource
        
    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Update
    include Besepa::ApiCalls::Destroy
        
    FIELDS = [:id, :name, :amount, :currency, :reference,
              :recurrent, :max_charges, :periodicity,
              :status]
    
    FIELDS.each do |f|
      attr_accessor f
    end    

  end
end