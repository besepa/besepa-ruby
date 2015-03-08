module Besepa
    
  module ApiCalls
    
    module Update
      
      def save(filters={})
        h = self.to_hash
        #id and status should not be send back to the server
        h.delete(:status) 
        h.delete(:id)
        #remove all nil values. Not updated.
        h.delete_if {|key, value| value.nil? }
        payload = {}
        payload[self.class.klass_name] = h
        response = put "/#{self.class.api_path(filters)}/#{id}", payload
        process_attributes(response['response'])
        self
      end
      
    end
  end
end