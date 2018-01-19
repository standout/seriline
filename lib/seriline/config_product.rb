require "seriline/responses/config_product_single_order_response"
require "seriline/responses/available_config_products_response"
require "seriline/request"

module Seriline
  class ConfigProduct
    def self.get_available(session)
      result = Request.get(Seriline::Endpoint.get_available_config_products_path,
                           { sessionKey: session.session_key })
      Seriline::AvailableConfigProductsResponse.new(result)
    end

    def self.order(session, product_id, data = {})
      result = Request.post(Seriline::Endpoint.config_product_single_order_path,
                            {
                              sessionKey: session.session_key,
                              Specification: { ProductId: product_id }
                            }.merge(data))
      Seriline::ConfigProductSingleOrderResponse.new(result)
    end
  end
end
