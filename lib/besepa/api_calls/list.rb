module Besepa
    
  module ApiCalls
    
    module List

      module ClassMethods
        
        def all(filters={})
          response = get "/#{api_path(filters)}"
          objects = Array.new
          if response['count'] > 0
            response['response'].each do |c|
              objects << self.new(c)
            end
          end
          objects
        end
        
        def find(id, filters={})
          response = get "/#{api_path(filters)}/#{id}"
          c = self.new(response['response'])
          c
        end
        
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    
    end
    
  end
  
end
