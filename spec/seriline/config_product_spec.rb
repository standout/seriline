require "seriline/config_product"
require "seriline/session_data"
require "spec_helper"

RSpec.describe Seriline::ConfigProduct do
  describe ".get_available" do
    let(:response) do
      {
        "Success": true,
        "ErrorMessage": "sample string 2",
        "Products": [
          {
            "ProductId": 1,
            "Name": "sample string 2",
            "ShortDescription": "sample string 3",
            "IsBatchProduct": true
          },
          {
            "ProductId": 1,
            "Name": "sample string 2",
            "ShortDescription": "sample string 3",
            "IsBatchProduct": true
          }
        ]
      }.to_json
    end

    let(:unsuccessful_response) do
      {
        "Success": false,
        "ErrorMessage": "unknown",
        "Products": [
          {
            "ProductId": 1,
            "Name": "sample string 2",
            "ShortDescription": "sample string 3",
            "IsBatchProduct": true
          },
          {
            "ProductId": 1,
            "Name": "sample string 2",
            "ShortDescription": "sample string 3",
            "IsBatchProduct": true
          }
        ]
      }.to_json
    end

    let(:available_uri) do
      Seriline::Endpoint.get_available_config_products_path(session_key: session.session_key)
    end

    let(:session) { Seriline::SessionData.new({valid_to: Time.now + 60**2, session_key: "key"}) }

    before { stub_request(:get, available_uri).to_return(body: response) }

    subject { Seriline::ConfigProduct.get_available(session) }

    it "must use the provided session" do
      subject

      expect(WebMock).to have_requested(:get, available_uri)
    end

    it "must return an array of config products" do
      expect(subject).to be_a_kind_of(Array)
      subject.each do |product|
        expect(product).to be_a_kind_of Seriline::ConfigProduct
      end
    end
  end
end
