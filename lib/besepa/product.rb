module Besepa

  class Product < Besepa::Resource
        
    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Create
        
    FIELDS = [:id, :name, :amount, :currency, :reference,
              :recurrent, :max_charges, :charge_on, :periodicity,
              :status]
    
    FIELDS.each do |f|
      attr_accessor f
    end    

  end
end