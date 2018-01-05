module Seriline
  class Client
    attr_reader :username,
                :api_key,
                :session

    def initialize(username = Seriline.config.username, api_key = Seriline.config.api_key)
      @username = username
      @api_key = api_key
      @session = nil
    end

    def self.with_connection(username = Seriline.config.username, api_key = Seriline.config.api_key)
      Seriline::Client.new(username, api_key).tap do |client|
        client.login
        if client.active?
          yield(client) if block_given?
          client.logout
        end
      end
    end

    def active?
      @session && @session.success
    end

    def login
      Seriline::Request.get(
        Seriline::Endpoint.login_path,
        { username: @username, apiKey: @api_key }
      ).tap(&store_session_info)
    end

    def logout
      Seriline::Request.get(
        Seriline::Endpoint.logout_path,
        { sessionKey: session.session_key }
      ).tap(&destroy_session_info)
    end

    private

    def store_session_info
      lambda { |response|
        @session = Seriline::Session.new(
          response["Success"],
          response["SessionKey"],
          response["ErrorMessage"],
          response["ValidTo"]
        )
      }
    end

    def destroy_session_info
      lambda { |response|
        @session = nil
      }
    end
  end
end
