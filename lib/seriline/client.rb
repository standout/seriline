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
        client.login
        if client.session.active?
          yield(client) if block_given?
          client.logout
        end
      end
    end

    def login
      return if @session.active?
      Seriline::Request.get(
        Seriline::Endpoint.login_path,
        { username: @username, apiKey: @api_key }
      ).tap(&update_session_info)
    end

    def logout
      return unless @session.active?
      Seriline::Request.get(
        Seriline::Endpoint.logout_path,
        { sessionKey: @session.session_key }
      ).tap(&update_session_info)
    end

    private

    def update_session_info
      lambda { |response|
        @session = Seriline::SessionData.new(response)
      }
    end
  end
end
