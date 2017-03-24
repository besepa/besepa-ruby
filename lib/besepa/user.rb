module Besepa
  class User < Besepa::Resource

    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Search
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Update
    include Besepa::ApiCalls::Destroy

    FIELDS = [:id, :name, :email, :account_id, :owner, :created_at, :updated_at, :last_sign_in_at, :time_zone, :notify_errors, :notify_mandate_signs]

    FIELDS.each do |f|
      attr_accessor f
    end
  end
end
