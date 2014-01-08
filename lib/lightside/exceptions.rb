module LightSide

  class ResourceNotFound < StandardError; end
  class ResourceNotCreated < StandardError; end

  class NotConfigured < StandardError
    def to_s
      "one ore more configuration settings is missing"
    end
  end

end
