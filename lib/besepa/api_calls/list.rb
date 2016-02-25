module Besepa
  module ApiCalls
    module List
      module ClassMethods
        def all(filters={})
          path = "/#{api_path(filters)}"
          params = filters.select{|x| [:page, :field, :value].include?(x)}
          response = get(path, params)

          Besepa::Collection.new(response, self)
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
