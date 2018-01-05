require "seriline/response_data"
require "spec_helper"

RSpec.describe Seriline::ResponseData do
  describe ".initialize" do
    it "must create readers for each attribute" do
      data = Seriline::ResponseData.new({ a: "1", b: "2" })

      expect(data.a).to eq "1"
      expect(data.b).to eq "2"
    end

    it "must ssssnake case" do
      raw = {
        Success: true,
        ControlKey: true,
        validTo: true,
        ABC: true
      }

      data = Seriline::ResponseData.new(raw)

      expect(data).to respond_to :success
      expect(data).to respond_to :control_key
      expect(data.valid_to)
      expect(data.abc)
    end
  end
end
