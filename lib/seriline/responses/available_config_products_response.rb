require "seriline/response_data"

module Seriline
  class AvailableConfigProductsResponse < Seriline::ResponseData
    attr_reader :success, :error_message, :products

    def initialize(attributes = {})
      super(attributes)
      serialize_products
    end

    private

    def serialize_products
      @products = @products.map {|product_hash| AvailableConfigProductNode.new(product_hash) }
    end
  end

  class AvailableConfigProductNode < Seriline::ResponseData
    attr_reader :product_id, :name, :short_description, :is_batch_product
  end
end
