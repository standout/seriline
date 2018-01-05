require "spec_helper"
require "seriline/session"
require "seriline/endpoint"

RSpec.describe Seriline::Session do
  describe "#active?" do
    let(:login_success_response) do
      {
        "Success": true,
        "SessionKey": "session_key",
        "ErrorMessage": "",
        "ValidTo": Time.now + 60 ** 2
      }
    end

    let(:session) { Seriline::Session.new(login_success_response) }

    it "must be able to be active" do
      expect(session).to be_active
    end

    it "must not be active if unsuccesful login" do
      login_success_response["Success"] = false

      expect(session).to_not be_active
    end

    it "must not be active if expired" do
      login_success_response["ValidTo"] = Time.now - 60 ** 2

      expect(session).to_not be_active
    end
  end
end

