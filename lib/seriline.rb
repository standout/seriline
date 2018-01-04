require "seriline/version"
require "seriline/request"

module Seriline
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield(config)
  end

  class Configuration
    attr_accessor :username, :api_key
  end
end
