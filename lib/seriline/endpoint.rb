require "uri"

module Seriline
  class Endpoint
    BASE_URI  = "https://api.webconnect.cloud/v2/api"

    {
      login: "/Authentication/Login",
      logout: "/Authentication/Logout",
      get_available_config_products: "/ConfigProduct/GetAvailable",
      config_product_single_order: "/ConfigProduct/SingleOrder",
      get_order_info: "/Order/GetOrderInfo"
    }.each do |action, path|
      define_singleton_method("#{action}_path") do |query = {}|
        URI(BASE_URI + path).tap do |uri|
          uri.query = URI.encode_www_form(query)
        end
      end
    end
  end
end
