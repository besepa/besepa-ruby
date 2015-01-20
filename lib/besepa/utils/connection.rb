require 'faraday'
require 'faraday_middleware'

module Besepa

  module Utils
  
      module Connection

      # Returns a Faraday::Connection object
      #
      # @param options [Hash] A hash of options
      # @return [Faraday::Connection]
      def connection(options={})
        options = options.merge(Besepa.options)
        @connection ||= Faraday.new ( options[:endpoint] ) do |conn|
          conn.request :json
          conn.response :json, :content_type => /\bjson$/
          conn.use :instrumentation
          conn.authorization( 'Bearer', options[:api_key])
          conn.adapter :net_http
        end
      end
    end
    
  end
  
end