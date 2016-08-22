module Besepa
  class Group < Besepa::Resource

    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Update
    include Besepa::ApiCalls::Destroy

    FIELDS = [:id, :name, :reference, :created_at]

    FIELDS.each do |f|
      attr_accessor f
    end

    def customers
      Customer.search({ field: :group_id, value: id})
    end

    def stats
      response = get "#{api_path}/stats"
      response['response']
    end

    def api_path(filters = {})
      "#{self.class.api_path(filters)}/#{CGI.escape(id)}"
    end

    protected

    def self.query_params(filters = {})
      filters = filters.dup
      filters.delete(:customer_id)
      filters
    end

    def self.api_path(filters={})
      if filters[:customer_id]
        "#{Customer.api_path}/#{CGI.escape(filters[:customer_id])}/groups"
      else
        "/groups"
      end
    end
  end
end
