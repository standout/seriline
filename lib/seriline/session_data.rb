require "seriline/response_data"
require "time"

module Seriline
  class SessionData < Seriline::ResponseData
    attr_reader :success, :session_key, :error_message, :valid_to

    def initialize(attributes = {})
      super(attributes)
      parse_valid_to
    end

    def active?
      success && valid_to > Time.now
    end

    private

    def parse_valid_to
      return if @valid_to.nil?
      @valid_to = Time.parse(@valid_to.to_s)
    end
  end
end
