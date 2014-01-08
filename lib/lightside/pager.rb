module LightSide
  class Pager
    include Enumerable

    attr_accessor :collection, :next_url, :params, :previous_url, :resource_builder, :resource_url, :url

    def initialize(model_class, params={})
      self.resource_url     = model_class.resource_url
      self.resource_builder = lambda { |hash| model_class.new(hash) }
      self.params           = { page: 1 }.merge(params)
      self.collection       = []
      self.url              = resource_path
    end

    def count
      collection.length
    end

    def each
      collection.each { |instance| yield instance }
    end

    def fetch
      self.collection = []
      fetch_page
      self
    end

    def fetch_page
      RestClient.get(url, Config.headers) do |response, request, result|
        case response.code
        when 200
          parsed_response   = JSON.parse(response)
          self.next_url     = parsed_response["next"]
          self.previous_url = parsed_response["previous"]
          parsed_response["results"].each do |resource|
            collection << resource_builder.call(resource)
          end
        end
      end
    end

    def less?
      !!previous_url
    end

    def more?
      !!next_url
    end

    def next
      raise "no more results" unless more?
      self.url = next_url
      fetch
    end

    def page_number
      params.fetch(:page, 1).to_i
    end

    def previous
      raise "no more results" unless less?
      self.url = previous_url
      fetch
    end

    def resource_path
      URI.join(resource_url, "?#{URI.encode_www_form(params)}").to_s
    end

  end
end
