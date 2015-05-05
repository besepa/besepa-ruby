require 'besepa/utils/request'
require 'besepa/utils/connection'
require 'besepa/utils/config'

module Besepa
        
  class Resource

    class <<self
      
     include Besepa::Utils::Connection
     include Besepa::Utils::Request
      
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

    attr_accessor :activities
    
    def initialize(attrs={})
      process_attributes(attrs)
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
    
    def klass_name
      self.class.name.split('::')[-1].downcase
    end
    
    protected 
    
      def handle_errors(http_status, response)
        Module.const_get(self.class.name).handle_errors(http_status, response)
      end
    
      def process_attributes(attrs)          
        self.class::FIELDS.each do |key|
          self.send("#{key.to_s}=", attrs[key.to_s] || attrs[key.to_sym])
        end
        process_activities(attrs)
      end
      
      def process_activities(attrs)
        if attrs['activities']
          self.activities = Array.new
          attrs['activities'].each do |a|
            self.activities << Besepa::Activity.new(a) 
          end
        end
      end

  end
    
  
end
