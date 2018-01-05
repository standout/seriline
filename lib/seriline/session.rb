require "seriline/response_data"
require "time"

module Seriline
  class Session < Seriline::ResponseData
    def initialize(response)
      transform_values(response)
      super(response)
    end

    def active?
      success && valid_to > Time.now
    end

    private

    def transform_values(response)
      valid_to = response["ValidTo"]
      return unless valid_to
      response["ValidTo"] = Time.parse(valid_to.to_s)
    end
  end
end
