require "seriline/config_product_single_order_data"
require "seriline/request"

module Seriline
  # Använd något sånt här för response
  # class ConfigProductResponse
  class ConfigProduct < Seriline::Model
    attr_reader :product_id, :name, :short_description, :is_batch_product

    def self.get_available(session)
      result = Request.get(Seriline::Endpoint.get_available_config_products_path,
                           { sessionKey: session.session_key })
      result["Products"].map {|product| Seriline::ConfigProduct.new(product)}
    end

    def order(session, data = {})
      result = Request.post(Seriline::Endpoint.config_product_single_order_path,
                            {
                              sessionKey: session.session_key,
                              ExternalId: @product_id
                            }.merge(data))
      Seriline::ConfigProductSingleOrderData.new(result)
    end
  end
end
