# Seriline

# Usage
## Authentication
For any Seriline request you must first login.
A session will be active for 60 minutes and during that session you can
use the other parts of the API.

To start a session `username` and `api_key` is required
which you can receive by contacting Seriline. To use the key in any
Seriline request you can store it by doing the following:

```ruby
Seriline::USERNAME = "my_user"
Seriline::API_KEY = "my_api_key"
```

To connect to the API either do it with block syntax:
```ruby
Seriline::Client.connect do |client|
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

- [X] `GET api/Authentication/Login?username={username}&apiKey={apiKey}`
- [X] `GET api/Authentication/Logout?sessionKey={sessionKey}`

## Configproducts
- [ ] `GET api/ConfigProduct/GetAvailable?sessionKey={sessionKey}`
- [ ] `GET api/ConfigProduct/GetConfigProductInfo?sessionKey={sessionKey}&productId={productId}	`
- [ ] `POST api/ConfigProduct/SingleOrder`
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
- [ ] `GET api/Order/GetOrderInfo?sessionKey={sessionKey}&orderId={orderId}`
