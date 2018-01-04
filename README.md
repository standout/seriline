# Seriline

# Usage
## Authentication
For any Seriline request you must first start a session.
A session will be active for 60 minutes and during that session you can
use the other parts of the API.

To start a session `username` and `api_key` is required
which you can receive by contacting Seriline. To use the key in any
Seriline request you can store it by doing the following:

```ruby
Seriline::USERNAME = "my_user"
Seriline::API_KEY = "my_api_key"
```

You can execute a session with block syntax.
This makes sure that the session is established and flushed.
The block will not be yielded unless the session is successfully established.

```ruby
Seriline::Session.open do |session|
  # <- Your awesome code goes here
end
```

- [X] `GET api/Authentication/Login?username={username}&apiKey={apiKey}`
- [X] `GET api/Authentication/Logout?sessionKey={sessionKey}`

### Cards
- [ ] `GET api/Card/GetProducedCards?sessionKey={sessionKey}&fromDateTime={fromDateTime}&toDateTime={toDateTime}`
- [ ] `GET api/Card/GetNotProducedCards?sessionKey={sessionKey}`
- [ ] `GET api/Card/GetCardPersonPhoto?sessionKey={sessionKey}&cardId={cardId}`
- [ ] `GET api/Card/GetCardStatusChanges?sessionKey={sessionKey}&fromDateTime={fromDateTime}`
- [ ] `GET api/Card/ChangeCardStatus?sessionKey={sessionKey}&configProductId={configProductId}&action={action}`

### Accessories
- [ ] `GET api/Accessories/GetAvailable?sessionKey={sessionKey}`

### Configproducts
- [ ] `GET api/ConfigProduct/GetAvailable?sessionKey={sessionKey}`
- [ ] `GET api/ConfigProduct/GetConfigProductInfo?sessionKey={sessionKey}&productId={productId}	`
- [ ] `POST api/ConfigProduct/SingleOrder`
- [ ] `POST api/ConfigProduct/BatchOrder`
- [ ] `GET api/ConfigProduct/GetProductionData?sessionKey={sessionKey}&configProductId={configProductId}`

### Orders
- [ ] `GET api/Order/GetOrderInfo?sessionKey={sessionKey}&orderId={orderId}`
