require "seriline/responses/login_response"
require "seriline/session"

module Seriline
  class Client
    attr_reader :username,
                :api_key,
                :session

    def initialize(username = Seriline.config.username, api_key = Seriline.config.api_key)
      @username = username
      @api_key = api_key
      @session = Seriline::Session.new
    end

    def self.with_connection(username = Seriline.config.username, api_key = Seriline.config.api_key)
      client = Seriline::Client.new(username, api_key)
      self.client_connection(client) { yield }
    end

    def self.client_connection(client)
      client.login
      yield(client) if client.session.active?
    ensure
      client.logout
    end

    def login
      return if @session.active?
      Seriline::Request.get(
        Seriline::Endpoint.login_path,
        { username: @username, apiKey: @api_key }
      ).tap(&store_session_info)
    end

    def logout
      return unless @session.active?
      Seriline::Request.get(
        Seriline::Endpoint.logout_path,
        { sessionKey: @session.session_key }
      ).tap(&destroy_session_info)
    end

    def get_available_config_products
      ConfigProduct.get_available(@session)
    end

    def order_config_product(product_id, data)
      ConfigProduct.order(@session, product_id, data)
    end

    def get_order_info(order_id)
      Order.get_order_info(session, order_id)
    end

    private

    def store_session_info
      lambda { |response|
        @session = Seriline::Session.new Seriline::LoginResponse.new(response)
      }
    end

    def destroy_session_info
      -> (_response) { @session = Seriline::Session.new }
    end
  end
end
