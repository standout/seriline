require "seriline/responses/order_info_response"

module Seriline
  class Order
    def self.get_order_info(session, order_id)
      result = Request.get(Seriline::Endpoint.get_order_info_path,
                          {
                            sessionKey: session.session_key,
                            orderId: order_id
                          })
      Seriline::OrderInfoResponse.new(result)
    end
  end
end
