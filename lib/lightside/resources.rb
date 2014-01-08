module LightSide
  module Resources

    def initialize(hash={})
      set_attributes_from_hash(hash)
    end

    def attributes
      self.class.attributes.inject({}) do |memo, attr|
        memo.merge(attr => self.__send__(attr))
      end
    end

    def delete
      self.class.delete_resource(id)
    end

    def id
      url && url.split("/").last
    end

    def reload
      self.class.resource(id) do |hash|
        set_attributes_from_hash(hash)
      end
      self
    end

    def update
      save
    end

    def save
      json = JSON.generate(writable_attributes)
      if id
        self.class.update_resource(id, json) { |hash| set_attributes_from_hash(hash) }
      else
        self.class.create_resource(json) { |hash| set_attributes_from_hash(hash) }
      end
      self
    end

    def set_attributes_from_hash(hash)
      self.class.attributes.each do |attr|
        self.__send__("#{attr.to_s}=", hash.fetch(attr, nil))
      end
    end

    def to_s
      %w(id url errors).map(&:to_sym).inject("#{self.class.name}") do |memo, attr|
        val = self.__send__(attr)
        memo << " #{attr}:#{val}" if val
        memo
      end
    end

    def writable_attributes
      self.class.writable_attributes.inject({}) do |memo, attr|
        memo.merge(attr => self.__send__(attr))
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.singleton_class.class_eval { attr_accessor :resource_base, :readonly_attributes, :writable_attributes }
    end

    module ClassMethods
      def all
        resources
      end

      def attributes
        @readonly_attributes.to_a + @writable_attributes.to_a + ["errors"]
      end

      def create(data)
        create_resource(data) { |hash| new(hash) }
      end

      def create_resource(data)
        RestClient.post(resource_url, data, Config.headers) do |response, request, result|
          case response.code
          when 201
            yield JSON.parse(response)
          when 400
            yield JSON.parse(data).merge!("errors" => JSON.parse(response))
          else
            raise response
          end
        end
      end

      def delete(id)
        delete_resource(id)
      end

      def delete_resource(id)
        RestClient.delete(resource_url(id), Config.headers) do |response, request, result|
          case response.code
          when 204
            return true
          when 404
            raise ResourceNotFound, "could not find #{name} with ID=#{id}"
          else
            raise response
          end
        end
      end

      def find(id)
        resource(id) { |hash| new(hash) }
      end

      def page(page_num)
        LightSide::Pager.new(self, { page: Integer(page_num) }).fetch
      end

      def query(query_params)
        resources(query_params)
      end

      def resource_url(id=nil)
        raise LightSide::NotConfigured unless Config.configured?
        [Config.base_url, "#{resource_base}/#{id}"].join("/")
      end

      def resources(params={})
        LightSide::Pager.new(self, params).fetch
      end

      def resource(id)
        RestClient.get(resource_url(id), Config.headers) do |response, request, result|
          case response.code
          when 200
            yield JSON.parse(response)
          when 404
            raise ResourceNotFound, "could not find #{name} with ID=#{id}"
          else
            raise response
          end
        end
      end

      def setup
        yield
        attributes.each { |attr| attr_accessor attr.to_s }
      end

      def update(id, data)
        update_resource(id, data) { |hash| new(hash) }
      end

      def update_resource(id, data)
        RestClient.put(resource_url(id), data, Config.headers) do |response, request, result|
          case response.code
          when 200
            yield JSON.parse(response)
          when 400
            yield ({"errors" => JSON.parse(response)})
          when 404
            raise ResourceNotFound, "could not find #{name} with ID=#{id}"
          else
            raise response
          end
        end
      end
    end

  end
end
