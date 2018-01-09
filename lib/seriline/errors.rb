module Seriline
  class Error < StandardError; end

  class RequestFailedError < Error
    def initialize(net_http_error)
      super build_message(net_http_error)
    end

    private

    def build_message(net_http_error)
      %(
        Net::HTTP failed to execute request with the following status:
        Status: #{net_http_error.code}
      )
    end
  end
end
