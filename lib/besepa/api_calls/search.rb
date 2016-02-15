module Besepa
  module ApiCalls
    module Search
      module ClassMethods

        def search(filters = {})
          response = get "/#{api_path}/search?field=#{filters[:field]}&value=#{filters[:value]}"
          objects = Array.new
          if response['count'] > 0
            response['response'].each do |c|
              objects << self.new(c)
            end
          end
          objects
        end

      end

      def self.included(base)
        base.extend(ClassMethods)
      end

    end
  end
end
