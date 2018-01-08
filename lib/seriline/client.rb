module Seriline
  class Client
    attr_reader :username,
                :api_key,
                :session

    def initialize(username = Seriline.config.username, api_key = Seriline.config.api_key)
      @username = username
      @api_key = api_key
      @session = Seriline::SessionData.new({})
    end

    def self.with_connection(username = Seriline.config.username, api_key = Seriline.config.api_key)
      Seriline::Client.new(username, api_key).tap do |client|
        begin
          client.login
          yield(client) if block_given? &&
            client.session.active?
        rescue
        ensure
          client.logout
        end
      end
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
      ConfigProduct.new(product_id: product_id)
        .order(@session, data)
    end

    def get_order_info(order_id)
      Order.get_order_info(session, order_id)
    end

    private

    def store_session_info
      lambda { |response|
        @session = Seriline::SessionData.new(
          response.merge(logged_in: true)
        )
      }
    end

    def destroy_session_info
      -> (_response) { @session = Seriline::SessionData.new({}) }
    end
  end
end
