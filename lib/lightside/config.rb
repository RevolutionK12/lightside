module LightSide

  def self.configure
    @configuration ||= LightSide::Config
    yield @configuration if block_given?
    @configuration
  end

  class Config
    singleton_class.class_eval do
      attr_accessor :auth_token, :base_url
    end

    def self.headers
      { "Authorization" => "Token #{auth_token}", "Content-Type" => "application/json" }
    end

    def self.configured?
      auth_token && base_url
    end
  end

end
