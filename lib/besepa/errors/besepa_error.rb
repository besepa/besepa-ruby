module Besepa

  module Errors
    
    class BesepaError < StandardError
      
      attr_reader :error
      attr_reader :description
      attr_reader :http_status
      attr_reader :messages

      def initialize(error=nil, description=nil, http_status=nil, messages=nil)
        @messages = messages
        @http_status = http_status
        @description = description
        @error = error
      end

      def to_s
        status_string = @http_status.nil? ? "" : "(Status #{@http_status}) "
        "#{status_string}#{@error} (#{@description})"
      end
      
    end
  
  end

end