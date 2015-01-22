module Besepa
    
  module ApiCalls
    
    module Destroy
      
      def destroy(filters={})
        response = delete "/#{self.class.api_path(filters)}/#{id}"
        process_attributes(response['response'])
        self
      end
      
    end
  end
end