# Seriline
Seriline provides an API for ordering their products. This gem provides a simple method
for connecting and using the API.
# Configuration
For any Seriline request you must first login.
A session will be active for 60 minutes and during that session you can
use the other parts of the API.

You can store details with a configuration block:
```ruby
# configure Seriline details
Seriline.configure do |config|
  config.username = username
  config.api_key = api_key
end
```
# Usage
All actions execute requests to the seriline API. This means something
could go wrong on the way. All returned data however; is returned as an
object with the `success?` method. If a request fails you can use that flag
along with `error_message` to troubleshoot eventual client problems.
## Authentication
To connect to the API either do it with block syntax:
```ruby
Seriline::Client.with_connection do |client|
  # <- Your awesome code goes here
end
```

Or manually by instantiating `Seriline::Client`:
```ruby
client = Seriline::Client.new
client.login
# <- Your awesome code goes here
client.logout
```

Both are the same. Using block syntax you won't have to worry about logging in and out.
If you have not configured seriline with username and api key you can provide that to any
of those methods.

- [X] `GET api/Authentication/Login?username={username}&apiKey={apiKey}`
- [X] `GET api/Authentication/Logout?sessionKey={sessionKey}`

## Configproducts
A config product is a custom product which you can order.

You can list your available config products like so:
```ruby
Seriline::Client.with_connection do |client|
  client.get_available_config_products
end
```
This returns an array of `ConfigProduct` instances.

When you have your product id you can proceed to do a single order.
```ruby
Seriline::Client.with_connection do |client|
  client.order_config_product(my_product_id, data)
end
```
This will return a `ConfigProductSingleOrderData` object which amongst other
things contains `order_id`. This key can be used for looking up more information
about this specific order and should thus be kept.

- [X] `GET api/ConfigProduct/GetAvailable?sessionKey={sessionKey}`
- [ ] `GET api/ConfigProduct/GetConfigProductInfo?sessionKey={sessionKey}&productId={productId}	`
- [X] `POST api/ConfigProduct/SingleOrder`
- [ ] `POST api/ConfigProduct/BatchOrder`
- [ ] `GET api/ConfigProduct/GetProductionData?sessionKey={sessionKey}&configProductId={configProductId}`

### Cards
- [ ] `GET api/Card/GetProducedCards?sessionKey={sessionKey}&fromDateTime={fromDateTime}&toDateTime={toDateTime}`
- [ ] `GET api/Card/GetNotProducedCards?sessionKey={sessionKey}`
- [ ] `GET api/Card/GetCardPersonPhoto?sessionKey={sessionKey}&cardId={cardId}`
- [ ] `GET api/Card/GetCardStatusChanges?sessionKey={sessionKey}&fromDateTime={fromDateTime}`
- [ ] `GET api/Card/ChangeCardStatus?sessionKey={sessionKey}&configProductId={configProductId}&action={action}`

### Accessories
- [ ] `GET api/Accessories/GetAvailable?sessionKey={sessionKey}`

### Orders
You can get information about an order by user `Seriline::Order`.
```ruby
Seriline::Client.with_connection do |client|
  client.get_order_info(order_id))
end
```

- [X] `GET api/Order/GetOrderInfo?sessionKey={sessionKey}&orderId={orderId}`
