module Besepa

  class Remittance < Besepa::Resource

    include Besepa::ApiCalls::List

    FIELDS = [:id, :collect_at, :send_at, :sent_at, :status, :scheme, :created_at, :debits_count, :debits_amount]

    attr_accessor :bank_account

    FIELDS.each do |f|
      attr_accessor f
    end

    def self.api_path(filters={})
      "/remittances"
    end

    def api_path(filters={})
      "#{self.class.api_path(filters)}/#{CGI.escape(id)}"
    end

    def stats
      response = get "#{api_path}/stats"
      response['response']
    end


    protected

      def process_attributes(attrs)
        self.class::FIELDS.each do |key|
          self.send("#{key.to_s}=", attrs[key.to_s] || attrs[key.to_sym])
        end
        self.bank_account = Besepa::BusinessAccount.new(attrs['bank_account']) if attrs['bank_account']
        process_activities(attrs)
        self
      end


  end
end
