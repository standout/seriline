require "seriline/response_data"

module Seriline
  class LoginResponse < Seriline::ResponseData
    attr_reader :success, :session_key, :error_message, :valid_to

    def initialize(attributes)
      super(attributes)
      parse_valid_to
    end

    private

    def parse_valid_to
      return if @valid_to.nil?
      @valid_to = Time.parse(@valid_to.to_s)
    end
  end
end
