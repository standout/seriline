module Seriline
  class Session
    attr_reader :username, :api_key, :session_key, :successful_login, :valid_to

    def initialize(username = Seriline::USERNAME, api_key = Seriline::API_KEY)
      @username = username
      @api_key = api_key
      @successful_login = false
    end

    def self.open(username = Seriline::USERNAME, api_key = Seriline::API_KEY)
      Seriline::Session.new(username, api_key).tap do |session|
        session.login
        if session.active?
          yield(session) if block_given?
          session.logout
        end
      end
    end

    def active?
      @successful_login &&
        @session_key &&
        !@session_key.empty?
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
        { sessionKey: @session_key }
      ).tap { @session_key = nil }
    end

    private

    def store_session_info
      lambda { |response|
        @successful_login = response["Success"]
        return unless @successful_login
        @session_key = response["SessionKey"]
        @valid_to = Time.new(response["ValidTo"])
      }
    end
  end
end
