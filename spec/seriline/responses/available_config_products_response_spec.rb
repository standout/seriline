require "seriline/responses/available_config_products_response"
require "spec_helper"

RSpec.describe Seriline::AvailableConfigProductsResponse do
  let(:raw_data) do
    {
      "Success": true,
      "ErrorMessage": "sample string 2",
      "Products": [
        {
          "ProductId": 1,
          "Name": "sample string 2",
          "ShortDescription": "sample string 3",
          "IsBatchProduct": true
        },
        {
          "ProductId": 1,
          "Name": "sample string 2",
          "ShortDescription": "sample string 3",
          "IsBatchProduct": true
        }
      ]
    }
  end

  it "must serialize products" do
    response = Seriline::AvailableConfigProductsResponse.new(raw_data)

    expect(response.products.all? {|product| product.is_a? Seriline::AvailableConfigProductNode })
      .to eq true
  end
end
