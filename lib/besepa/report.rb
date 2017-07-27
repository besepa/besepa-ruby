module Besepa

  class Report < Besepa::Resource

    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Search

    FIELDS = [:id, :until_at, :since_at, :kind, :created_at,
              :document_file_name, :document_file_size, :status]

    FIELDS.each do |f|
      attr_accessor f
    end

    def self.klass_name
      "report"
    end


    def download_url
      response = get "/#{self.class.api_path}/#{CGI.escape(id)}/download"
      response["response"]["url"]
    end

  end
end