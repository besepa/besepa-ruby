module Besepa

  class Membership < Besepa::Resource
    
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Destroy

    FIELDS = [:id, :customer_id, :group_id]

    FIELDS.each do |f|
      attr_accessor f
    end

    def create(filters)
      self.create([], filters)
    end

    protected 
    
      def self.api_path(filters={})
        "#{Customer.api_path}/#{CGI.escape(filters[:customer_id])}/memberships/#{CGI.escape(filters[:group_id])}"
      end

      def api_path(filters={})
        "#{Customer.api_path}/#{CGI.escape(filters[:customer_id])}/memberships/#{CGI.escape(filters[:group_id])}"
      end
  end
end