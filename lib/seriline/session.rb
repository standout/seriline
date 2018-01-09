require "seriline/responses/login_response"
require "time"

module Seriline
  class Session
    attr_reader :login_response

    def initialize(login_response = nil)
      @login_response = login_response
    end

    def active?
      @login_response &&
        @login_response.success &&
        @login_response.valid_to > Time.now
    end

    def session_key
      @login_response && @login_response.session_key
    end
  end
end
