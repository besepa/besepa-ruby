module Besepa

  class Product < Besepa::Resource

    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Search
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Update
    include Besepa::ApiCalls::Destroy

    FIELDS = [:id, :name, :amount, :currency, :reference,
              :recurrent, :max_charges, :periodicity, :period_count,
              :status, :created_at]

    FIELDS.each do |f|
      attr_accessor f
    end

  end
end
