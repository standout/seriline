require "seriline/order_info_data"
require "seriline/order"
require "spec_helper"

RSpec.describe Seriline::Order do
  describe ".get_order_info" do
    let(:session) { Seriline::SessionData.new({valid_to: Time.now + 60**2, session_key: session_key}) }
    let(:uri) { Seriline::Endpoint.get_order_info_path(sessionKey: session_key, orderId: order_id) }
    let(:session_key) { "my_session" }
    let(:order_id) { 1}

    let(:successful_response) do
      {
        "Success": true,
        "ErrorMessage": "sample string 2",
        "OrderId": 3,
        "Status": "sample string 4"
      }.to_json
    end

    before do
      stub_request(:get, uri)
        .to_return(body: successful_response)
    end

    subject { Seriline::Order.get_order_info(session, order_id) }

    it "must use the provided session and order id" do
      subject

      expect(WebMock).to have_requested(:get, uri)
    end

    it "must return a order info response" do
      expect(subject).to be_a_kind_of Seriline::OrderInfoData
    end
  end
end
