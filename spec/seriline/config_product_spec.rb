require "seriline/config_product_single_order_data"
require "seriline/config_product"
require "seriline/session_data"
require "spec_helper"

RSpec.describe Seriline::ConfigProduct do
  let(:session_key) { "session_key" }
  let(:session) { Seriline::SessionData.new({valid_to: Time.now + 60**2, session_key: session_key}) }

  describe "#order" do
    let(:response) do
      {
        "Success": true,
        "ErrorMessage": "sample string 2",
        "OrderId": 3,
        "ConfigProductId": 4
      }
    end

    let(:order_uri) { Seriline::Endpoint.config_product_single_order_path }
    let(:config_product) { Seriline::ConfigProduct.new({product_id: 1}) }

    before do
      stub_request(:post, order_uri)
    end

    it "must use the provided product id" do
      expect(config_product.product_id).to eq 1
    end

    it "must use the provided session" do
      config_product.order(session)
      expect(WebMock).to have_requested(:post, order_uri).
        with {|request| JSON.parse(request.body)["sessionKey"] == session_key }
    end

    # I'm not entirely sure about this. I have to ask Seriline whether this is the actual
    # key to use.
    it "must set the external id to the provided id" do
      config_product.order(session)

      expect(WebMock).to have_requested(:post, order_uri).
        with {|request| JSON.parse(request.body)["ExternalId"] == config_product.product_id }
    end

    it "must use the provided data" do
      address = "Gatsatan 4"
      config_product.order(session, { DeliveryAdress: address })

      expect(WebMock).to have_requested(:post, order_uri).
        with {|request| JSON.parse(request.body)["DeliveryAdress"] == address }
    end

    it "must return a config product single order response" do
      result = config_product.order(session)

      expect(result).to be_a_kind_of(Seriline::ConfigProductSingleOrderData)
    end
  end

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
      Seriline::Endpoint.get_available_config_products_path(sessionKey: session.session_key)
    end

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
