require 'besepa/utils/request'
require 'besepa/utils/connection'
require 'besepa/utils/config'

module Besepa
        
  class Resource

    class <<self
      
     include Besepa::Utils::Connection
     include Besepa::Utils::Request

      protected 
      
      def api_path(filters={})
        "#{klass_name}s"
      end
      
      def klass_name
        name.split('::')[-1].downcase
      end
      
      def handle_errors(http_status, response)
        error = response['error']
        desc = response['error_description']
        msgs = response['messages'] 
        if error == 'invalid_resource'
          raise Besepa::Errors::InvalidResourceError.new(error, desc, http_status, msgs)
        elsif error == 'not_found'
          raise Besepa::Errors::ResourceNotFoundError.new(error, desc, http_status, msgs)
        else
          raise Besepa::Errors::BesepaError.new(error, desc, http_status, msgs)
        end
      end
      
    end

    include Besepa::Utils::Connection
    include Besepa::Utils::Request

    def initialize(attrs={})
      process_attributes(attrs)
    end
    
    def save
      h = self.to_hash
      #id and status should not be send back to the server
      h.delete(:status) 
      h.delete(:id)
      attrs = { self.class.klass_name => h }
      save_or_update(attrs)
    end
    
    def to_hash
      values = {}
      self.class::FIELDS.each do |key|
        values[key] = self.send("#{key.to_s}")
      end
      values
    end
    
    def serializable_hash
      to_hash
    end
    
    def as_json
      to_hash.as_json
    end
    
    protected 
    
      def process_attributes(attrs)          
        self.class::FIELDS.each do |key|
          self.send("#{key.to_s}=", attrs[key.to_s] || attrs[key.to_sym])
        end
      end
    
      def save_or_update(attrs)
        response = nil
        if id
          response = put "/#{self.api_path}/#{id}", attrs
        else
          response = post "/#{self.api_path}", attrs
        end
        process_attributes(response['response'])
      end
      
      def api_path(filters={})
        self.class.api_path
      end


  end
    
  
end
