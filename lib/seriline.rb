require "seriline/version"
require "seriline/request"
require "seriline/session"
require "seriline/order"
require "seriline/errors"
require "seriline/endpoint"
require "seriline/config_product"
require "seriline/client"

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
