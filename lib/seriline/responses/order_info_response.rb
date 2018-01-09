require "seriline/response_data"

module Seriline
  class OrderInfoResponse < Seriline::ResponseData
    attr_reader :success, :error_message, :order_id, :status
  end
end
