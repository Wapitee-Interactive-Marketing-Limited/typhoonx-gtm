# TyphoonX for Google Tag Manager

A Google Tag Manager web tag template that sends storefront e-commerce events to [TyphoonX](https://typhoonx.io), Wapitee's data tracking platform. It sends the same events and payloads as [`@wapitee/typhoonx-react`](https://github.com/Wapitee-Interactive-Marketing-Limited/typhoonx-js/tree/main/packages/react).

## Setup

1. In your GTM web container, go to **Templates → Tag Templates → Search Gallery** and add **TyphoonX**. Until the template is in the gallery, import [`template.tpl`](./template.tpl) with **Templates → New → ⋮ → Import**.
2. Create a **TyphoonX** tag. Enter your **Merchant ID** (`TPX-…`), **Shop ID** and the site's **GA4 Measurement ID** (`G-…`), whose current session is sent as `ga_session_id`.
3. Choose an **Event** and a trigger:

| Event                         | Typical trigger                                                       |
| ----------------------------- | --------------------------------------------------------------------- |
| Page View                     | Initialization or All Pages, plus History Change for single-page apps |
| View Item                     | Custom Event `view_item`                                              |
| View Item List                | Custom Event `view_item_list`                                         |
| Add to Cart                   | Custom Event `add_to_cart`                                            |
| Remove from Cart              | Custom Event `remove_from_cart`                                       |
| View Cart                     | Custom Event `view_cart`                                              |
| Search                        | Custom Event `search`                                                 |
| Use the data layer event name | Custom Event matching `^(view_item\|view_item_list\|add_to_cart\|remove_from_cart\|view_cart\|search)$` (regex) |

With **Use the data layer event name**, one tag covers all e-commerce events: the event's `event` key in the data layer chooses the TyphoonX event, and unsupported event names are ignored.

Page View also sends `first_visit` the first time a visitor is seen.

If your site sets a Content-Security-Policy, allow `https://spell.typhoonx.io` in both `script-src` and `connect-src`.

### Event parameters

With **Read GA4 e-commerce data from the data layer** checked (the default), the tag reads the standard [GA4 e-commerce](https://developers.google.com/analytics/devguides/collection/ga4/ecommerce) data layer:

```js
dataLayer.push({ecommerce: null});
dataLayer.push({
  event: 'add_to_cart',
  ecommerce: {
    currency: 'USD',
    value: 25,
    items: [
      {item_id: 'SKU-1', item_name: 'Hat', item_brand: 'Acme', price: 25, quantity: 1},
    ],
  },
});
```

| TyphoonX field                   | Data layer key                                 | Tag field                 |
| -------------------------------- | ---------------------------------------------- | ------------------------- |
| `currency`                       | `ecommerce.currency`                           | Currency                  |
| `value`                          | `ecommerce.value`                              | Value                     |
| `items`                          | `ecommerce.items`                              | Items                     |
| `item_list_id`, `item_list_name` | `ecommerce.item_list_id`, `ecommerce.item_list_name` | Item List ID, Item List Name |
| `search_term`                    | `search_term`                                  | Search Term               |

A filled-in tag field takes precedence over the data layer. **Items** takes a variable returning an array of items with `item_id`, `item_name`, `item_brand`, `price` and `quantity`. If no value is given, it defaults to the sum of `price × quantity`.

### Identity

**Cookie Domain** sets the domain of the `__typhoon_client_id` cookie. It defaults to the broadest domain the browser allows, e.g. `example.com`.

Each event also carries the GA4 client ID, Google Ads click IDs (`gclid`, `gbraid`, `wbraid`) and Meta's `_fbp` / `_fbc` when present.

### Consent

By default the tag sends nothing, and writes no cookie or local storage, while Consent Mode's `analytics_storage` is denied. Uncheck **Require analytics_storage consent** under **Consent and Advanced Settings** only if you enforce consent another way, for example through the tag's trigger or **Consent Settings**.

## How events are sent

GTM's sandboxed JavaScript can only send GET requests, and TyphoonX collects JSON POSTs. The tag loads a small helper, [`helper/typhoonx-gtm.js`](./helper/typhoonx-gtm.js), served from `https://spell.typhoonx.io/gtm/typhoonx-gtm.js`. The helper sends each event with `navigator.sendBeacon`, falling back to a keepalive `fetch`, and adds the browser's user agent.

## Development

`template.tpl` is the template as exported from the GTM Template Editor. Its tests live in the `___TESTS___` section and run in the editor's **Tests** tab. To run them locally against stand-ins for the sandbox APIs:

```bash
node test/run-template-tests.mjs
```

To release a version, commit the template, then add that commit's SHA to the top of `versions` in [`metadata.yaml`](./metadata.yaml).

## License

[Apache 2.0](./LICENSE) © Wapitee Interactive
