require "seriline/responses/config_product_single_order_response"
require "seriline/responses/login_response"
require "seriline/config_product"
require "seriline/session"
require "spec_helper"

RSpec.describe Seriline::ConfigProduct do
  let(:session_key) { "session_key" }
  let(:session) do
    Seriline::Session.new(
      Seriline::LoginResponse.new(valid_to: Time.now + 60**2, session_key: session_key)
    )
  end

  let(:product_id) { 1 }

  describe ".order" do
    let(:response) do
      {
        "Success": true,
        "ErrorMessage": "sample string 2",
        "OrderId": 3,
        "ConfigProductId": 4
      }
    end

    let(:order_uri) { Seriline::Endpoint.config_product_single_order_path }

    before do
      stub_request(:post, order_uri)
    end

    describe "specification" do
      it "must use the provided product id" do
        Seriline::ConfigProduct.order(session, product_id)
        expect(WebMock).to have_requested(:post, order_uri).
          with {|request| JSON.parse(request.body)["Specification"]["ProductId"] == product_id }
      end
    end

    it "must merge the provided data" do
      Seriline::ConfigProduct.order(session, product_id, {
        DeliveryAdress: {
          CompanyName: "Company"
        }
      })
      expect(WebMock).to have_requested(:post, order_uri).
          with {|request| JSON.parse(request.body)["DeliveryAdress"]["CompanyName"] == "Company" }
    end

    it "must use the provided session" do
      Seriline::ConfigProduct.order(session, product_id)
      expect(WebMock).to have_requested(:post, order_uri).
        with {|request| JSON.parse(request.body)["sessionKey"] == session_key }
    end

    it "must use the provided data" do
      address = "Gatsatan 4"
      Seriline::ConfigProduct.order(session, product_id, { DeliveryAdress: address })

      expect(WebMock).to have_requested(:post, order_uri).
        with {|request| JSON.parse(request.body)["DeliveryAdress"] == address }
    end

    it "must return a config product single order response" do
      result = Seriline::ConfigProduct.order(session, product_id)

      expect(result).to be_a_kind_of(Seriline::ConfigProductSingleOrderResponse)
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

    it "must return available config product response" do
      expect(subject).to be_a_kind_of(Seriline::AvailableConfigProductsResponse)
    end
  end
end
