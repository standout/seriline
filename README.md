# Seriline

# Features
### Cards
- [ ] `GET api/Card/GetProducedCards?sessionKey={sessionKey}&fromDateTime={fromDateTime}&toDateTime={toDateTime}`
- [ ] `GET api/Card/GetNotProducedCards?sessionKey={sessionKey}`
- [ ] `GET api/Card/GetCardPersonPhoto?sessionKey={sessionKey}&cardId={cardId}`
- [ ] `GET api/Card/GetCardStatusChanges?sessionKey={sessionKey}&fromDateTime={fromDateTime}`
- [ ] `GET api/Card/ChangeCardStatus?sessionKey={sessionKey}&configProductId={configProductId}&action={action}`

### Authentication
- [ ] `GET api/Authentication/Login?username={username}&apiKey={apiKey}`
- [ ] `GET api/Authentication/Logout?sessionKey={sessionKey}`

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
