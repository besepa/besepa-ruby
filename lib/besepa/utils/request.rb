module Besepa
  
  module Utils
    
    # Defines HTTP request methods
    module Request

      END_POINT_URL_PREFIX = "/api/1"

      # Perform an HTTP DELETE request
      def delete(path, params={}, options={})
        request(:delete, path, params, options)
      end

      # Perform an HTTP GET request
      def get(path, params={}, options={})
        request(:get, path, params, options)
      end

      # Perform an HTTP POST request
      def post(path, params={}, options={})
        request(:post, path, params, options)
      end

      # Perform an HTTP PUT request
      def put(path, params={}, options={})
        request(:put, path, params, options)
      end

    private

      # Perform an HTTP request
      def request(method, path, params, options)
        response = connection(options).run_request(method, nil, nil, nil) do |request|
          request.options[:raw] = true if options[:raw]
          case method.to_sym
          when :delete, :get
            request.url(END_POINT_URL_PREFIX + path, params)
          when :post, :put
            request.path = END_POINT_URL_PREFIX + path
            request.body = params unless params.empty?
          end
        end
        options[:raw] ? response : handle_response(response)
      end

      def handle_response(response)
        body = response.body
        body['error'] ? handle_errors(response.status, body) : body
      end
      
    end
    
  end
  
end