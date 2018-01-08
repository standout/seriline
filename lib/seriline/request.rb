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
        response_body = http.request(request_object(body)).body
        return {} if response_body.empty?
        return JSON.parse(response_body, {quirks_mode: true})
      end
    end

    private

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
