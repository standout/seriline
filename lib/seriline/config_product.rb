require "seriline/request"

module Seriline
  class ConfigProduct < Seriline::ResponseData
    attr_reader :product_id, :name, :short_description, :is_batch_product

    def self.get_available(session)
      result = Request.get(Seriline::Endpoint.get_available_config_products_path,
                           { session_key: session.session_key })
      result["Products"].map {|product| Seriline::ConfigProduct.new(product)}
    end
  end
end
