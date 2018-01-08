require "net/http"

module Seriline
  class Request
    class << self
      def get(uri, body = {})
        Request.new(uri).execute(body)
      end

      def post(uri, body = {})
        Request.new(uri, method: "POST")
               .execute(body)
      end
    end

    def initialize(uri, method: "GET")
      @method = method
      @uri = URI(uri)
    end

    def execute(body = {})
      Net::HTTP.start(@uri.host, @uri.port) do |http|
        response = http.request(request_object(body))
        evaluate_response(response)
        return parse_response(response)
      end
    end

    private

    def evaluate_response(response)
      response.value
    # TODO: remove the e var
    rescue => e
      raise Seriline::RequestFailedError.new(response)
    end

    def parse_response(response)
      return {} if response.body.empty?
      JSON.parse(response.body, {quirks_mode: true})
    end

    def request_object(body)
      @request_object ||= case @method
                          when "GET"
                            @uri.query = URI.encode_www_form(body)
                            Net::HTTP::Get.new(@uri)
                          when "POST"
                            Net::HTTP::Post.new(@uri).tap do |req|
                              req.content_type = "application/json"
                              req.body = body.to_json
                            end
                          end
    end
  end
end
