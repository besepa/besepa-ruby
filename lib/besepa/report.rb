module Besepa

  class Report < Besepa::Resource

    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Search

    FIELDS = [:id, :until_at, :since_at, :kind, :created_at]

    FIELDS.each do |f|
      attr_accessor f
    end

  end
end