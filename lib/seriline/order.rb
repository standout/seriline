require "seriline/order_info_data"

module Seriline
  class Order < Seriline::ResponseData
    def self.get_order_info(session, order_id)
      result = Request.get(Seriline::Endpoint.get_order_info_path,
                          {
                            sessionKey: session.session_key,
                            orderId: order_id
                          })
      Seriline::OrderInfoData.new(result)
    end
  end
end
