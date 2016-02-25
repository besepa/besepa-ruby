module Besepa
  class Collection
    include Enumerable
    attr_accessor :items, :pages, :per_page, :total, :current_page
    attr_reader :pagination

    def initialize(response, klass)
      @pagination = false
      @items = []
      process_response(response, klass)
    end

    def each &block
      @items.each{|item| block.call(item)}
    end

    alias_method :size, :count

    private

    def process_response(response, klass)
      if response['pagination']
        @pagination = true
        self.per_page = response['pagination']['per_page']
        self.current_page = response['pagination']['current']
        self.total = response['pagination']['count']
        self.pages = response['pagination']['pages']
      end

      response['response'].each do |c|
        @items << klass.new(c)
      end
    end

  end
end
