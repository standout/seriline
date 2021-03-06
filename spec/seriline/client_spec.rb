require "seriline/endpoint"
require "seriline/session"
require "seriline/client"
require "spec_helper"

RSpec.describe Seriline::Client do
  let(:session_key) { "my_session_key"}
  let(:username) { "my_name" }
  let(:api_key) { "my_key" }
  let(:client) { Seriline::Client.new }

  let(:login_success_response) do
    {
      "Success": true,
      "SessionKey": session_key,
      "ErrorMessage": "",
      "ValidTo": Time.now + 60 * 60
    }.to_json
  end

  let(:login_failure_response) do
    {
      "Success": false,
      "SessionKey": "",
      "ErrorMessage": "",
      "ValidTo": Time.now + 60 * 60
    }.to_json
  end

  let(:login_uri) do
    query = { username: username, apiKey: api_key }
    Seriline::Endpoint.login_path(query)
  end

  let(:logout_uri) do
    query = { sessionKey: session_key }
    Seriline::Endpoint.logout_path(query)
  end

  let(:stub_login_request) do
    stub_request(:get, login_uri)
      .to_return(body: login_success_response)
  end

  let(:stub_logout_request) { stub_request :get, logout_uri }

  before do
    # configure Seriline details
    Seriline.configure do |config|
      config.username = username
      config.api_key = api_key
    end

    # stub requests
    stub_login_request
    stub_logout_request
  end

  describe "#login" do
    it "must start a seriline session" do
      username = "a_user"
      api_key = "api_key"
      query = { username: username, apiKey: api_key }
      login_uri = Seriline::Endpoint.login_path(query)
      stub_request(:get, login_uri)
        .to_return(body: login_success_response)

      client = Seriline::Client.new(username, api_key)
      client.login

      expect(WebMock).to have_requested(:get, login_uri)
    end

    it "must default to seriline authentication details" do
      client.login

      expect(WebMock).to have_requested(:get, login_uri)
    end

    it "must store the session" do
      client.login

      session = client.session
      expect(session).to_not be_nil
      expect(session.login_response.success).to_not be_nil
      expect(session.login_response.session_key).to_not be_nil
      expect(session.login_response.error_message).to_not be_nil
      expect(session.login_response.valid_to).to_not be_nil
    end

    it "must not make a login request if already logged in" do
      client.login
      allow(client.session).to receive(:active?).and_return(true)

      client.login

      expect(WebMock).to have_requested(:get, login_uri).once
    end
  end

  describe "#logout" do
    it "must end a seriline session" do
      client.login
      client.logout

      expect(WebMock).to have_requested(:get, logout_uri)
    end

    it "must make the session inactive" do
      client.login
      client.logout

      expect(client.session).to_not be_active
    end

    it "must not create a logout request if already inactive" do
      client.login
      allow(client.session).to receive(:active?).and_return(false)

      client.logout

      expect(WebMock).to_not have_requested(:get, logout_uri)
    end
  end

  describe ".with_connection" do
    it "must start a seriline session" do
      expect_any_instance_of(Seriline::Client).to receive(:login).and_return(login_success_response)
      allow_any_instance_of(Seriline::Client).to receive(:logout)

      Seriline::Client.with_connection(username, api_key)
    end

    it "must end a seriline session when done" do
      expect_any_instance_of(Seriline::Client).to receive(:logout)

      Seriline::Client.with_connection {}
    end

    it "must end a seriline session upon crash" do
      allow_any_instance_of(Seriline::Client).to receive(:login).and_raise
      expect_any_instance_of(Seriline::Client).to receive(:logout)

      begin
        Seriline::Client.with_connection {}
      rescue
      end
    end

    it "must return result from the yielded block" do
      expect(Seriline::Client.with_connection { "my_result" }).to eq("my_result")
    end

    it "must yield the given block" do
      expect { |b| Seriline::Client.with_connection(&b) }.to yield_control
    end

    it "must yield the session instance to the block" do
      Seriline::Client.with_connection do |session|
        expect(client).to_not be_nil
        expect(client).to be_an_instance_of(Seriline::Client)
      end
    end

    it "must not yield the block if login is unsuccesful" do
      stub_request(:get, login_uri)
        .to_return(body: login_failure_response)

      expect { |b| Seriline::Client.with_connection(&b) }.to_not yield_control
    end
  end
end

