module Besepa

  class Activity < Besepa::Resource
        
    FIELDS = [:id, :key, :created_at, :owner]
    FIELDS.each do |f|
      attr_accessor f
    end    
      
  end
end