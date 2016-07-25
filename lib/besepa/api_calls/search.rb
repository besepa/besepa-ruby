module Besepa
  module ApiCalls
    module Search
      module ClassMethods
        def search(filters = {})
          path = "/#{api_path}/search"
          params = filters.select{|x| [:page, :query, :field, :value].include?(x)}
          response = get(path, params)
          Besepa::Collection.new(response, self)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
