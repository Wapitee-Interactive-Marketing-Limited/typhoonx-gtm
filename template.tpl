___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "TyphoonX",
  "categories": [
    "ANALYTICS",
    "CONVERSIONS",
    "ATTRIBUTION"
  ],
  "brand": {
    "id": "github.com_Wapitee-Interactive-Marketing-Limited",
    "displayName": "TyphoonX"
  },
  "description": "Sends storefront e-commerce events (page views, product and list views, cart changes and searches) to TyphoonX, Wapitee's data tracking platform.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "merchantId",
    "displayName": "Merchant ID",
    "simpleValueType": true,
    "alwaysInSummary": true,
    "help": "Your TyphoonX merchant ID, e.g. <code>TPX-XXXXXX</code>.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "shopId",
    "displayName": "Shop ID",
    "simpleValueType": true,
    "alwaysInSummary": true,
    "help": "Your TyphoonX shop ID.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "SELECT",
    "name": "eventType",
    "displayName": "Event",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "page_view",
        "displayValue": "Page View"
      },
      {
        "value": "view_item",
        "displayValue": "View Item"
      },
      {
        "value": "view_item_list",
        "displayValue": "View Item List"
      },
      {
        "value": "add_to_cart",
        "displayValue": "Add to Cart"
      },
      {
        "value": "remove_from_cart",
        "displayValue": "Remove from Cart"
      },
      {
        "value": "view_cart",
        "displayValue": "View Cart"
      },
      {
        "value": "search",
        "displayValue": "Search"
      },
      {
        "value": "auto",
        "displayValue": "Use the data layer event name"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "page_view",
    "alwaysInSummary": true,
    "help": "The TyphoonX event to send. <b>Page View</b> also sends <code>first_visit</code> for new visitors. <b>Use the data layer event name</b> sends the GA4 event name pushed to the data layer (e.g. <code>add_to_cart</code>), so one tag can fire on all supported e-commerce events; other event names are ignored."
  },
  {
    "type": "GROUP",
    "name": "eventParameters",
    "displayName": "Event Parameters",
    "groupStyle": "ZIPPY_OPEN",
    "enablingConditions": [
      {
        "paramName": "eventType",
        "paramValue": "page_view",
        "type": "NOT_EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "useDataLayer",
        "checkboxText": "Read GA4 e-commerce data from the data layer",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "Reads <code>ecommerce.currency</code>, <code>ecommerce.value</code>, <code>ecommerce.items</code>, <code>ecommerce.item_list_id</code>, <code>ecommerce.item_list_name</code> and <code>search_term</code> from the data layer, as pushed for GA4 e-commerce events. Fields filled in below take precedence."
      },
      {
        "type": "TEXT",
        "name": "currency",
        "displayName": "Currency",
        "simpleValueType": true,
        "help": "ISO 4217 currency code, e.g. <code>USD</code>. Used by item, cart and item list events."
      },
      {
        "type": "TEXT",
        "name": "value",
        "displayName": "Value",
        "simpleValueType": true,
        "help": "Total value of the items. Used by View Item, Add to Cart, Remove from Cart and View Cart. Defaults to the sum of <code>price × quantity</code> over the items."
      },
      {
        "type": "TEXT",
        "name": "items",
        "displayName": "Items",
        "simpleValueType": true,
        "help": "A variable returning an array of GA4 items (<code>item_id</code>, <code>item_name</code>, <code>item_brand</code>, <code>price</code>, <code>quantity</code>). Used by View Item, Add to Cart, Remove from Cart and View Cart."
      },
      {
        "type": "TEXT",
        "name": "itemListId",
        "displayName": "Item List ID",
        "simpleValueType": true,
        "help": "Used by View Item List."
      },
      {
        "type": "TEXT",
        "name": "itemListName",
        "displayName": "Item List Name",
        "simpleValueType": true,
        "help": "Used by View Item List."
      },
      {
        "type": "TEXT",
        "name": "searchTerm",
        "displayName": "Search Term",
        "simpleValueType": true,
        "help": "Used by Search."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "identity",
    "displayName": "Identity",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "TEXT",
        "name": "measurementId",
        "displayName": "GA4 Measurement ID",
        "simpleValueType": true,
        "help": "Optional GA4 measurement ID (<code>G-XXXXXXXXXX</code>). When set, the GA4 session ID is sent as <code>ga_session_id</code>.",
        "valueValidators": [
          {
            "type": "REGEX",
            "args": [
              "^(G-[A-Za-z0-9]+)?$"
            ],
            "errorMessage": "Enter a GA4 measurement ID such as G-XXXXXXXXXX, or leave this empty."
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "cookieDomain",
        "displayName": "Cookie Domain",
        "simpleValueType": true,
        "help": "Domain of the first-party <code>__typhoon_client_id</code> cookie. Leave empty to use the broadest domain the browser allows (e.g. <code>example.com</code> for <code>shop.example.com</code>)."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "advanced",
    "displayName": "Consent and Advanced Settings",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "requireConsent",
        "checkboxText": "Require analytics_storage consent",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "When checked, nothing is sent and no cookie or local storage entry is written while Consent Mode's <code>analytics_storage</code> is denied. Uncheck only if consent is enforced another way, e.g. by the tag's trigger."
      },
      {
        "type": "TEXT",
        "name": "endpoint",
        "displayName": "Collection Endpoint",
        "simpleValueType": true,
        "defaultValue": "https://spell.typhoonx.io/api/v1/receive",
        "help": "Leave as is unless TyphoonX gives you a different endpoint.",
        "valueValidators": [
          {
            "type": "REGEX",
            "args": [
              "^https://.+$"
            ],
            "errorMessage": "The endpoint must be an https:// URL."
          }
        ]
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const callInWindow = require('callInWindow');
const copyFromDataLayer = require('copyFromDataLayer');
const generateRandom = require('generateRandom');
const getCookieValues = require('getCookieValues');
const getQueryParameters = require('getQueryParameters');
const getReferrerUrl = require('getReferrerUrl');
const getTimestampMillis = require('getTimestampMillis');
const getType = require('getType');
const getUrl = require('getUrl');
const injectScript = require('injectScript');
const isConsentGranted = require('isConsentGranted');
const localStorage = require('localStorage');
const logToConsole = require('logToConsole');
const makeInteger = require('makeInteger');
const makeNumber = require('makeNumber');
const makeString = require('makeString');
const Math = require('Math');
const Object = require('Object');
const readAnalyticsStorage = require('readAnalyticsStorage');
const setCookie = require('setCookie');
const templateStorage = require('templateStorage');

const HELPER_URL = 'https://spell.typhoonx.io/gtm/typhoonx-gtm.js';
const SEND_FUNCTION = 'typhoonxGtmSend';
const DEFAULT_ENDPOINT = 'https://spell.typhoonx.io/api/v1/receive';

const CLIENT_ID_COOKIE = '__typhoon_client_id';
const CLIENT_ID_MAX_AGE = 31536000;
const FIRST_VISIT_TIME_KEY = '__typhoon_first_visit_time';
const FIRST_VISIT_URL_KEY = '__typhoon_first_visit_url';
const PAGE_HISTORY_KEY = 'pageHistory';

const ITEMS_EVENTS = {
  add_to_cart: true,
  remove_from_cart: true,
  view_cart: true,
  view_item: true
};

const SUPPORTED_EVENTS = {
  add_to_cart: true,
  page_view: true,
  remove_from_cart: true,
  search: true,
  view_cart: true,
  view_item: true,
  view_item_list: true
};

const log = (message) => {
  logToConsole('[TyphoonX] ' + message);
};

const isBlank = (value) => value === undefined || value === null || value === '';

const firstPresent = (values, fallback) => {
  for (let i = 0; i < values.length; i++) {
    if (!isBlank(values[i])) return values[i];
  }
  return fallback;
};

const objectOrEmpty = (value) => (getType(value) === 'object' ? value : {});

const assign = (target, source) => {
  Object.keys(source).forEach((key) => {
    if (source[key] !== undefined) target[key] = source[key];
  });
  return target;
};

const firstCookie = (name) => {
  const values = getCookieValues(name);
  return values && values.length > 0 && !isBlank(values[0]) ? values[0] : undefined;
};

const queryParam = (name) => {
  const value = getQueryParameters(name);
  return isBlank(value) ? undefined : makeString(value);
};

const pad = (number, width) => {
  let text = makeString(number);
  while (text.length < width) text = '0' + text;
  return text;
};

// Sandboxed JS has no Date, so convert epoch milliseconds to an ISO 8601 UTC
// string by hand (days-to-civil algorithm by Howard Hinnant).
const isoTimestamp = (millis) => {
  const days = Math.floor(millis / 86400000);
  let rest = millis - days * 86400000;
  const hours = Math.floor(rest / 3600000);
  rest -= hours * 3600000;
  const minutes = Math.floor(rest / 60000);
  rest -= minutes * 60000;
  const seconds = Math.floor(rest / 1000);
  const ms = rest - seconds * 1000;

  const z = days + 719468;
  const era = Math.floor(z / 146097);
  const doe = z - era * 146097;
  const yoe = Math.floor(
    (doe - Math.floor(doe / 1460) + Math.floor(doe / 36524) - Math.floor(doe / 146096)) / 365
  );
  const doy = doe - (365 * yoe + Math.floor(yoe / 4) - Math.floor(yoe / 100));
  const mp = Math.floor((5 * doy + 2) / 153);
  const day = doy - Math.floor((153 * mp + 2) / 5) + 1;
  const month = mp < 10 ? mp + 3 : mp - 9;
  const year = yoe + era * 400 + (month <= 2 ? 1 : 0);

  return pad(year, 4) + '-' + pad(month, 2) + '-' + pad(day, 2) + 'T' +
    pad(hours, 2) + ':' + pad(minutes, 2) + ':' + pad(seconds, 2) + '.' + pad(ms, 3) + 'Z';
};

const uuid = () => {
  const hex = '0123456789abcdef';
  let id = '';
  for (let i = 0; i < 36; i++) {
    if (i === 8 || i === 13 || i === 18 || i === 23) {
      id += '-';
    } else if (i === 14) {
      id += '4';
    } else if (i === 19) {
      id += '89ab'.charAt(generateRandom(0, 3));
    } else {
      id += hex.charAt(generateRandom(0, 15));
    }
  }
  return id;
};

const recordFirstVisit = (url, timestamp) => {
  if (!localStorage || localStorage.getItem(FIRST_VISIT_TIME_KEY) !== null) return;
  localStorage.setItem(FIRST_VISIT_TIME_KEY, timestamp);
  localStorage.setItem(FIRST_VISIT_URL_KEY, url);
};

const takeFirstVisit = () => {
  if (!localStorage) return undefined;
  const time = localStorage.getItem(FIRST_VISIT_TIME_KEY);
  const url = localStorage.getItem(FIRST_VISIT_URL_KEY);
  localStorage.removeItem(FIRST_VISIT_TIME_KEY);
  localStorage.removeItem(FIRST_VISIT_URL_KEY);
  return time && url ? {time: time, url: url} : undefined;
};

const getOrCreateClientId = (url, timestamp) => {
  const existing = firstCookie(CLIENT_ID_COOKIE);
  if (existing) return existing;

  recordFirstVisit(url, timestamp);

  const id = uuid();
  setCookie(CLIENT_ID_COOKIE, id, {
    domain: isBlank(data.cookieDomain) ? 'auto' : data.cookieDomain,
    path: '/',
    'max-age': CLIENT_ID_MAX_AGE,
    samesite: 'Lax',
    secure: makeString(getUrl('protocol')).indexOf('https') === 0
  }, false);
  return id;
};

// Kept across tag executions so single-page app navigations report the
// previous in-app URL as the referrer.
const referrerFor = (url) => {
  const history = templateStorage.getItem(PAGE_HISTORY_KEY) || {url: null, previousUrl: null};
  if (history.url !== url) {
    history.previousUrl = history.url;
    history.url = url;
  }
  templateStorage.setItem(PAGE_HISTORY_KEY, history);
  return history.previousUrl || getReferrerUrl() || '';
};

const withoutGPrefix = (measurementId) =>
  measurementId.indexOf('G-') === 0 ? measurementId.substring(2) : measurementId;

const afterSecondDot = (value, prefix) => {
  if (!value || value.indexOf(prefix) !== 0) return undefined;
  const parts = value.split('.');
  const rest = parts.slice(2).join('.');
  return parts.length >= 3 && rest !== '' ? rest : undefined;
};

const googleIds = () => {
  const ids = {};
  const analytics = objectOrEmpty(readAnalyticsStorage());

  if (!isBlank(analytics.client_id)) ids.ga_client_id = makeString(analytics.client_id);

  if (!isBlank(data.measurementId) && getType(analytics.sessions) === 'array') {
    const wanted = withoutGPrefix(makeString(data.measurementId));
    analytics.sessions.forEach((session) => {
      if (
        ids.ga_session_id === undefined &&
        getType(session) === 'object' &&
        !isBlank(session.session_id) &&
        withoutGPrefix(makeString(session.measurement_id)) === wanted
      ) {
        ids.ga_session_id = makeString(session.session_id);
      }
    });
  }

  ids.gbraid = queryParam('gbraid');
  ids.gclid = afterSecondDot(firstCookie('_gcl_aw'), 'GCL.') || queryParam('gclid');
  ids.wbraid = queryParam('wbraid');
  return ids;
};

const metaPixelIds = (now) => {
  const fbclid = queryParam('fbclid');
  return {
    fbc: firstCookie('_fbc') || (fbclid ? 'fb.1.' + makeString(now) + '.' + fbclid : undefined),
    fbp: firstCookie('_fbp')
  };
};

const toItem = (item) => {
  const source = objectOrEmpty(item);
  return {
    item_brand: makeString(firstPresent([source.item_brand, source.itemBrand], '')),
    item_id: makeString(firstPresent([source.item_id, source.itemId], '')),
    item_name: makeString(firstPresent([source.item_name, source.itemName], '')),
    price: makeString(firstPresent([source.price], 0)),
    quantity: makeInteger(firstPresent([source.quantity], 1))
  };
};

const itemsTotal = (items) => {
  let total = 0;
  items.forEach((item) => {
    const line = makeNumber(item.price) * item.quantity;
    // Sandboxed JS has no isNaN; NaN is the only value not equal to itself.
    if (line === line) total += line;
  });
  return Math.round(total * 100) / 100;
};

const eventName = data.eventType === 'auto' ? makeString(copyFromDataLayer('event')) : data.eventType;

if (SUPPORTED_EVENTS[eventName] !== true) {
  log('Ignoring unsupported event "' + eventName + '".');
  data.gtmOnSuccess();
  return;
}

if (data.requireConsent !== false && !isConsentGranted('analytics_storage')) {
  log('analytics_storage consent is not granted; "' + eventName + '" was not sent.');
  data.gtmOnSuccess();
  return;
}

const ecommerce = data.useDataLayer !== false ? objectOrEmpty(copyFromDataLayer('ecommerce')) : {};
const now = getTimestampMillis();
const timestamp = isoTimestamp(now);
const url = getUrl();
const currency = firstPresent([data.currency, ecommerce.currency]);

const shared = (withCurrency) => {
  const payload = {
    client_id: getOrCreateClientId(url, timestamp),
    merchant_id: makeString(data.merchantId),
    referrer: referrerFor(url),
    request_page_url: url,
    shop_id: makeString(data.shopId),
    timestamp: timestamp
  };
  if (withCurrency && !isBlank(currency)) payload.currency = makeString(currency);
  assign(payload, metaPixelIds(now));
  assign(payload, googleIds());
  return payload;
};

const buildPayloads = () => {
  if (eventName === 'page_view') {
    const pageView = assign(shared(false), {event: 'page_view'});
    const payloads = [pageView];
    const firstVisit = takeFirstVisit();
    if (firstVisit) {
      payloads.push(assign(assign({}, pageView), {
        event: 'first_visit',
        request_page_url: firstVisit.url,
        timestamp: firstVisit.time
      }));
    }
    return payloads;
  }

  if (ITEMS_EVENTS[eventName] === true) {
    const rawItems = firstPresent([data.items, ecommerce.items]);
    const items = getType(rawItems) === 'array' ? rawItems.map(toItem) : [];
    const value = firstPresent([data.value, ecommerce.value]);
    return [assign(shared(true), {
      event: eventName,
      items: items,
      value: makeString(isBlank(value) ? itemsTotal(items) : value)
    })];
  }

  if (eventName === 'view_item_list') {
    return [assign(shared(true), {
      event: 'view_item_list',
      item_list_id: makeString(firstPresent([data.itemListId, ecommerce.item_list_id], '')),
      item_list_name: makeString(firstPresent([data.itemListName, ecommerce.item_list_name], ''))
    })];
  }

  const dataLayerSearchTerm = data.useDataLayer !== false ? copyFromDataLayer('search_term') : undefined;
  return [assign(shared(false), {
    event: 'search',
    search_term: makeString(firstPresent([data.searchTerm, dataLayerSearchTerm], ''))
  })];
};

const payloads = buildPayloads();
const endpoint = isBlank(data.endpoint) ? DEFAULT_ENDPOINT : data.endpoint;

injectScript(HELPER_URL, () => {
  payloads.forEach((payload) => {
    callInWindow(SEND_FUNCTION, endpoint, payload);
  });
  data.gtmOnSuccess();
}, () => {
  log('Could not load ' + HELPER_URL + '; "' + eventName + '" was not sent.');
  data.gtmOnFailure();
}, HELPER_URL);


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedKeys",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "event"
              },
              {
                "type": 1,
                "string": "ecommerce"
              },
              {
                "type": 1,
                "string": "search_term"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_consent",
        "versionId": "1"
      },
      "param": [
        {
          "key": "consentTypes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "analytics_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_url",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_referrer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "cookieNames",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "__typhoon_client_id"
              },
              {
                "type": 1,
                "string": "_gcl_aw"
              },
              {
                "type": 1,
                "string": "_fbc"
              },
              {
                "type": 1,
                "string": "_fbp"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "set_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedCookies",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "name"
                  },
                  {
                    "type": 1,
                    "string": "domain"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "session"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "__typhoon_client_id"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "/"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_local_storage",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "__typhoon_first_visit_time"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "__typhoon_first_visit_url"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_template_storage",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_analytics_storage",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://spell.typhoonx.io/gtm/typhoonx-gtm.js"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "typhoonxGtmSend"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: page_view for a new visitor also sends first_visit and sets the client id
  code: |-
    runCode(mockData);

    assertApi('gtmOnSuccess').wasCalled();
    assertApi('injectScript').wasCalled();
    assertThat(sent.length).isEqualTo(2);
    assertThat(sent[0].name).isEqualTo('typhoonxGtmSend');
    assertThat(sent[0].endpoint).isEqualTo(ENDPOINT);
    assertThat(sent[0].payload).isEqualTo({
      client_id: CLIENT_ID,
      event: 'page_view',
      merchant_id: 'TPX-TEST',
      referrer: 'https://www.google.com/',
      request_page_url: PAGE_URL,
      shop_id: '123456789',
      timestamp: NOW_ISO
    });
    assertThat(sent[1].payload).isEqualTo({
      client_id: CLIENT_ID,
      event: 'first_visit',
      merchant_id: 'TPX-TEST',
      referrer: 'https://www.google.com/',
      request_page_url: PAGE_URL,
      shop_id: '123456789',
      timestamp: NOW_ISO
    });

    assertThat(cookieWrites.length).isEqualTo(1);
    assertThat(cookieWrites[0].name).isEqualTo('__typhoon_client_id');
    assertThat(cookieWrites[0].value).isEqualTo(CLIENT_ID);
    assertThat(cookieWrites[0].options).isEqualTo({
      domain: 'auto',
      path: '/',
      'max-age': 31536000,
      samesite: 'Lax',
      secure: true
    });
    assertThat(storage.__typhoon_first_visit_time).isUndefined();
    assertThat(storage.__typhoon_first_visit_url).isUndefined();
- name: first_visit keeps the landing page recorded by an earlier event
  code: |-
    mockData.eventType = 'view_item';
    runCode(mockData);
    assertThat(sent[0].payload.event).isEqualTo('view_item');
    assertThat(storage.__typhoon_first_visit_url).isEqualTo(PAGE_URL);

    pageUrl = 'https://shop.example.com/cart';
    mockData.eventType = 'page_view';
    runCode(mockData);

    assertThat(sent.length).isEqualTo(3);
    assertThat(sent[1].payload.event).isEqualTo('page_view');
    assertThat(sent[1].payload.request_page_url).isEqualTo('https://shop.example.com/cart');
    assertThat(sent[2].payload.event).isEqualTo('first_visit');
    assertThat(sent[2].payload.request_page_url).isEqualTo(PAGE_URL);
    assertThat(cookieWrites.length).isEqualTo(1);
- name: returning visitor keeps its client id and gets no first_visit
  code: |-
    cookies.__typhoon_client_id = 'existing-id';

    runCode(mockData);

    assertThat(sent.length).isEqualTo(1);
    assertThat(sent[0].payload.event).isEqualTo('page_view');
    assertThat(sent[0].payload.client_id).isEqualTo('existing-id');
    assertApi('setCookie').wasNotCalled();
- name: view_item reads GA4 e-commerce data from the data layer
  code: |-
    mockData.eventType = 'view_item';
    dataLayer.ecommerce = {
      currency: 'USD',
      value: 25,
      items: [
        {item_id: 'SKU-1', item_name: 'Hat', item_brand: 'Acme', price: 25, quantity: 1}
      ]
    };

    runCode(mockData);

    assertApi('gtmOnSuccess').wasCalled();
    assertThat(sent.length).isEqualTo(1);
    assertThat(sent[0].payload).isEqualTo({
      client_id: CLIENT_ID,
      currency: 'USD',
      event: 'view_item',
      items: [
        {item_brand: 'Acme', item_id: 'SKU-1', item_name: 'Hat', price: '25', quantity: 1}
      ],
      merchant_id: 'TPX-TEST',
      referrer: 'https://www.google.com/',
      request_page_url: PAGE_URL,
      shop_id: '123456789',
      timestamp: NOW_ISO,
      value: '25'
    });
- name: Fields override the data layer and value defaults to the item total
  code: |-
    mockData.eventType = 'add_to_cart';
    mockData.currency = 'EUR';
    mockData.items = [
      {itemId: 'SKU-2', itemName: 'Scarf', itemBrand: 'Acme', price: '19.99', quantity: 3},
      {item_id: 'SKU-3', price: 0.1, quantity: '2'}
    ];
    dataLayer.ecommerce = {currency: 'USD', items: [{item_id: 'IGNORED'}]};

    runCode(mockData);

    const payload = sent[0].payload;
    assertThat(payload.event).isEqualTo('add_to_cart');
    assertThat(payload.currency).isEqualTo('EUR');
    assertThat(payload.value).isEqualTo('60.17');
    assertThat(payload.items).isEqualTo([
      {item_brand: 'Acme', item_id: 'SKU-2', item_name: 'Scarf', price: '19.99', quantity: 3},
      {item_brand: '', item_id: 'SKU-3', item_name: '', price: '0.1', quantity: 2}
    ]);
- name: Data layer is ignored when reading it is turned off
  code: |-
    mockData.eventType = 'view_cart';
    mockData.useDataLayer = false;
    dataLayer.ecommerce = {currency: 'USD', value: 10, items: [{item_id: 'SKU-1'}]};

    runCode(mockData);

    const payload = sent[0].payload;
    assertThat(payload.event).isEqualTo('view_cart');
    assertThat(payload.currency).isUndefined();
    assertThat(payload.items).isEqualTo([]);
    assertThat(payload.value).isEqualTo('0');
- name: view_item_list sends the list id and name without items
  code: |-
    mockData.eventType = 'view_item_list';
    dataLayer.ecommerce = {
      currency: 'USD',
      item_list_id: 'summer',
      item_list_name: 'Summer Sale',
      items: [{item_id: 'SKU-1'}]
    };

    runCode(mockData);

    const payload = sent[0].payload;
    assertThat(payload.event).isEqualTo('view_item_list');
    assertThat(payload.currency).isEqualTo('USD');
    assertThat(payload.item_list_id).isEqualTo('summer');
    assertThat(payload.item_list_name).isEqualTo('Summer Sale');
    assertThat(payload.items).isUndefined();
    assertThat(payload.value).isUndefined();
- name: search sends the search term without currency
  code: |-
    mockData.eventType = 'search';
    dataLayer.search_term = 'red hat';
    dataLayer.ecommerce = {currency: 'USD'};

    runCode(mockData);

    const payload = sent[0].payload;
    assertThat(payload.event).isEqualTo('search');
    assertThat(payload.search_term).isEqualTo('red hat');
    assertThat(payload.currency).isUndefined();
- name: Data layer event name mode sends supported events and ignores others
  code: |-
    mockData.eventType = 'auto';
    dataLayer.event = 'remove_from_cart';
    dataLayer.ecommerce = {value: 5, items: [{item_id: 'SKU-1', price: 5, quantity: 1}]};

    runCode(mockData);

    assertThat(sent.length).isEqualTo(1);
    assertThat(sent[0].payload.event).isEqualTo('remove_from_cart');

    dataLayer.event = 'gtm.js';
    runCode(mockData);

    assertThat(sent.length).isEqualTo(1);
    assertApi('gtmOnFailure').wasNotCalled();
- name: Nothing is sent or stored without analytics_storage consent
  code: |-
    consent = false;

    runCode(mockData);

    assertApi('gtmOnSuccess').wasCalled();
    assertApi('injectScript').wasNotCalled();
    assertApi('setCookie').wasNotCalled();
    assertThat(sent.length).isEqualTo(0);
    assertThat(storage.__typhoon_first_visit_time).isUndefined();
- name: Consent check can be turned off
  code: |-
    consent = false;
    mockData.requireConsent = false;

    runCode(mockData);

    assertThat(sent.length).isEqualTo(2);
- name: Google and Meta ids are attached
  code: |-
    cookies.__typhoon_client_id = 'existing-id';
    cookies._gcl_aw = 'GCL.1700000000.CjwKCAcookie';
    cookies._fbp = 'fb.1.1690000000000.123456789';
    queryParams = {gclid: 'from-url', gbraid: 'gb-1', wbraid: 'wb-1', fbclid: 'IwAR-click'};
    analytics = {
      client_id: '1234567890.1690000000',
      sessions: [
        {measurement_id: 'G-OTHER', session_id: '111', session_number: 1},
        {measurement_id: 'G-ABC123', session_id: '1700000000', session_number: 4}
      ]
    };
    mockData.measurementId = 'G-ABC123';

    runCode(mockData);

    const payload = sent[0].payload;
    assertThat(payload.ga_client_id).isEqualTo('1234567890.1690000000');
    assertThat(payload.ga_session_id).isEqualTo('1700000000');
    assertThat(payload.gclid).isEqualTo('CjwKCAcookie');
    assertThat(payload.gbraid).isEqualTo('gb-1');
    assertThat(payload.wbraid).isEqualTo('wb-1');
    assertThat(payload.fbp).isEqualTo('fb.1.1690000000000.123456789');
    assertThat(payload.fbc).isEqualTo('fb.1.1700000000000.IwAR-click');
- name: Click ids fall back to the URL and ga_session_id needs a measurement ID
  code: |-
    cookies.__typhoon_client_id = 'existing-id';
    cookies._fbc = 'fb.1.1690000000000.cookie-click';
    queryParams = {gclid: 'from-url', fbclid: 'IwAR-click'};
    analytics = {
      client_id: '1234567890.1690000000',
      sessions: [{measurement_id: 'G-ABC123', session_id: '1700000000', session_number: 4}]
    };

    runCode(mockData);

    const payload = sent[0].payload;
    assertThat(payload.gclid).isEqualTo('from-url');
    assertThat(payload.fbc).isEqualTo('fb.1.1690000000000.cookie-click');
    assertThat(payload.ga_client_id).isEqualTo('1234567890.1690000000');
    assertThat(payload.ga_session_id).isUndefined();
    assertThat(payload.gbraid).isUndefined();
- name: Single-page app navigations use the previous page as referrer
  code: |-
    cookies.__typhoon_client_id = 'existing-id';

    runCode(mockData);
    pageUrl = 'https://shop.example.com/collections/hats';
    runCode(mockData);
    runCode(mockData);

    assertThat(sent[0].payload.referrer).isEqualTo('https://www.google.com/');
    assertThat(sent[1].payload.referrer).isEqualTo(PAGE_URL);
    assertThat(sent[2].payload.referrer).isEqualTo(PAGE_URL);
- name: Custom cookie domain and endpoint are used
  code: |-
    mockData.cookieDomain = '.example.com';
    mockData.endpoint = 'https://staging.typhoonx.io/api/v1/receive';

    runCode(mockData);

    assertThat(cookieWrites[0].options.domain).isEqualTo('.example.com');
    assertThat(sent[0].endpoint).isEqualTo('https://staging.typhoonx.io/api/v1/receive');
- name: Tag fails when the helper script cannot load
  code: |-
    helperLoads = false;

    runCode(mockData);

    assertApi('gtmOnFailure').wasCalled();
    assertApi('gtmOnSuccess').wasNotCalled();
    assertThat(sent.length).isEqualTo(0);
- name: Timestamps are ISO 8601 in UTC
  code: |-
    cookies.__typhoon_client_id = 'existing-id';
    mock('getTimestampMillis', () => 1709210096789);

    runCode(mockData);

    assertThat(sent[0].payload.timestamp).isEqualTo('2024-02-29T12:34:56.789Z');
setup: |-
  const ENDPOINT = 'https://spell.typhoonx.io/api/v1/receive';
  const PAGE_URL = 'https://shop.example.com/products/hat';
  const NOW_ISO = '2023-11-14T22:13:20.000Z';
  const CLIENT_ID = 'ffffffff-ffff-4fff-bfff-ffffffffffff';

  const mockData = {
    merchantId: 'TPX-TEST',
    shopId: '123456789',
    eventType: 'page_view',
    useDataLayer: true,
    requireConsent: true
  };

  let pageUrl = PAGE_URL;
  let queryParams = {};
  let analytics = {};
  let consent = true;
  let helperLoads = true;
  const cookies = {};
  const dataLayer = {};
  const storage = {};
  const pageStorage = {};
  const cookieWrites = [];
  const sent = [];

  mock('getUrl', (component) => component === 'protocol' ? 'https' : pageUrl);
  mock('getQueryParameters', (key) => queryParams[key]);
  mock('getReferrerUrl', () => 'https://www.google.com/');
  mock('getTimestampMillis', () => 1700000000000);
  mock('generateRandom', (min, max) => max);
  mock('getCookieValues', (name) => cookies[name] ? [cookies[name]] : []);
  mock('setCookie', (name, value, options) => {
    cookies[name] = value;
    cookieWrites.push({name: name, value: value, options: options});
  });
  mock('copyFromDataLayer', (key) => dataLayer[key]);
  mock('readAnalyticsStorage', () => analytics);
  mock('isConsentGranted', (type) => type === 'analytics_storage' ? consent : true);
  mockObject('localStorage', {
    getItem: (key) => storage[key] === undefined ? null : storage[key],
    setItem: (key, value) => {
      storage[key] = value;
      return true;
    },
    removeItem: (key) => {
      storage[key] = undefined;
    }
  });
  mockObject('templateStorage', {
    getItem: (key) => pageStorage[key],
    setItem: (key, value) => {
      pageStorage[key] = value;
    },
    removeItem: (key) => {
      pageStorage[key] = undefined;
    },
    clear: () => undefined
  });
  mock('injectScript', (url, onSuccess, onFailure) => {
    if (helperLoads) {
      onSuccess();
    } else {
      onFailure();
    }
  });
  mock('callInWindow', (name, endpoint, payload) => {
    sent.push({name: name, endpoint: endpoint, payload: payload});
  });


___NOTES___

Created for the TyphoonX Community Template Gallery submission.
