require "spec_helper"
require "seriline/session"
require "seriline/endpoint"

RSpec.describe Seriline::Session do
  let(:session_key) { "my_session_key"}
  let(:username) { Seriline::USERNAME }
  let(:api_key) { Seriline::API_KEY }
  let(:session) { Seriline::Session.new }

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
      "SessionKey": "is_a_session_key_returned?",
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

  before { stub_login_request; stub_logout_request }

  describe "#login" do
    it "must start a seriline session" do
      username = "a_user"
      api_key = "api_key"
      query = { username: username, apiKey: api_key }
      login_uri = Seriline::Endpoint.login_path(query)
      stub_request(:get, login_uri)
        .to_return(body: login_success_response)

      session = Seriline::Session.new(username, api_key)
      session.login

      expect(WebMock).to have_requested(:get, login_uri)
    end

    it "must default to seriline authentication details" do
      session.login

      expect(WebMock).to have_requested(:get, login_uri)
    end

    it "must store the expiration date" do
      session.login

      expect(session.valid_to).to_not eq nil
      expect(session.valid_to).to be_a_kind_of(Time)
    end
  end

  describe "#logout" do
    it "must end a seriline session" do
      session.login
      session.logout

      expect(WebMock).to have_requested(:get, logout_uri)
    end

    it "must discard the session key" do
      session.login
      session.logout

      expect(session.session_key).to eq nil
    end
  end

  describe "#active?" do
    it "must become true after login" do
      session.login

      expect(session).to be_active
    end

    it "must be false when session key is not set" do
      session.login
      session.instance_variable_set(:@session_key, "session_key")

      expect(session).to be_active
    end

    it "must become false after an unsuccessful login" do
      stub_request(:get, login_uri)
        .to_return(body: login_failure_response)

      session.login

      expect(session).to_not be_active
    end

    it "must become false after logout" do
      session.login
      session.logout

      expect(session).to_not be_active
    end

    it "must be false when session key is nil" do
      session.instance_variable_set(:@session_key, nil)

      expect(session).to_not be_active
    end
  end

  describe ".open" do
    it "must start a seriline session" do
      expect_any_instance_of(Seriline::Session).to receive(:login).and_return(login_success_response)
      allow_any_instance_of(Seriline::Session).to receive(:logout)

      Seriline::Session.open(username, api_key)
    end

    it "must end a seriline session when done" do
      expect_any_instance_of(Seriline::Session).to receive(:logout)

      Seriline::Session.open
    end

    it "must return a session" do
      expect(Seriline::Session.open).to be_an_instance_of(Seriline::Session)
    end

    it "must yield the given block" do
      expect { |b| Seriline::Session.open(&b) }.to yield_control
    end

    it "must yield the session instance to the block" do
      Seriline::Session.open do |session|
        expect(session).to_not be_nil
        expect(session).to be_an_instance_of(Seriline::Session)
      end
    end

    it "must not yield the block if login is unsuccesful" do
      stub_request(:get, login_uri)
        .to_return(body: login_failure_response)

      expect { |b| Seriline::Session.open(&b) }.to_not yield_control
    end
  end
end

