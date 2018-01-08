require "seriline/response_data"

module Seriline
  class ConfigProductSingleOrderData < Seriline::ResponseData
    attr_reader :success, :error_message, :order_id, :config_product_id
  end
end
