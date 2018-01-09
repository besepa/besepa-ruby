module Besepa
  module ApiCalls
    module Create
      module ClassMethods
        def create(params, filters={})
          payload = {}
          payload[klass_name] = params
          response = post "/#{api_path(filters)}", payload
          self.new(response['response'])
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
