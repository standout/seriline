require "seriline/errors"
require "seriline/request"
require "spec_helper"
require "uri"

RSpec.describe Seriline::Request do
  let(:base_uri) { "https://www.example.com" }

  describe ".get" do
    it "must make a get request" do
      body = { "message" => "hello world" }
      stub_request(:get, base_uri).to_return(body: body.to_json)

      result = Seriline::Request.get(base_uri)
      expect(result).to eq body
    end

    it "must be able to provide params as hash" do
      body = { "message" => "hola mundo" }
      uri = "#{base_uri}?#{URI.encode_www_form(body)}"
      stub_request(:get, uri).to_return do |request|
        {
          body: Hash[URI.decode_www_form(
            URI(request.uri.to_s).query
          )].to_json
        }
      end

      result = Seriline::Request.get(base_uri, body)
      expect(result).to eq body
    end
  end

  describe ".post" do
    it "must make a post request" do
      body = { "message" => "hello world" }
      stub_request(:post, base_uri).to_return(body: body.to_json)

      result = Seriline::Request.post(base_uri)
      expect(result).to eq body
    end

    it "must be able to provide params as hash" do
      body = { "message" => "hola mundo" }
      stub_request(:post, base_uri).to_return {|request| { body: request.body } }

      result = Seriline::Request.post(base_uri, body)
      expect(result).to eq body
    end
  end

  describe "#execute" do
    it "must be able to return a single value" do
      body = true
      stub_request(:get, base_uri).to_return(body: body.to_json)

      result = Seriline::Request.new(base_uri).execute
      expect(result).to eq body
    end

    it "must return the result as a hash" do
      body = { "message" => "hello world" }
      stub_request(:get, base_uri).to_return(body: body.to_json)

      result = Seriline::Request.new(base_uri).execute
      expect(result).to eq body
    end

    it "must return an empty hash if no response body given" do
      stub_request(:get, base_uri)

      result = Seriline::Request.new(base_uri).execute
      expect(result).to eq({})
    end

    it "must raise an error if request failed" do
      stub_request(:get, base_uri).to_return(status: 400)

      expect { Seriline::Request.new(base_uri).execute }.to raise_error Seriline::RequestFailedError
    end

    it "must include a useful error message when request failed" do
      stub_request(:get, base_uri).to_return(status: 400)

      expected_message = %(
        Net::HTTP failed to execute request with the following status:
        Status: 400
      )

      expect { Seriline::Request.new(base_uri).execute }.to raise_error expected_message
    end
  end
end
