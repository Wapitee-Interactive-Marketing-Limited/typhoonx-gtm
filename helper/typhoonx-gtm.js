/*
 * Transport for the TyphoonX Google Tag Manager template.
 *
 * GTM's sandboxed JavaScript can only send GET requests, while the TyphoonX
 * collection endpoint accepts JSON POSTs. The template injects this file and
 * calls `window.typhoonxGtmSend(endpoint, payload)` for each event.
 *
 * Must stay ES5: it runs unbundled on every site that uses the template.
 */
(function () {
  if (typeof window.typhoonxGtmSend === 'function') return;

  window.typhoonxGtmSend = function (endpoint, payload) {
    var event = {};
    for (var key in payload) {
      if (Object.prototype.hasOwnProperty.call(payload, key)) {
        event[key] = payload[key];
      }
    }
    event.user_agent = window.navigator.userAgent;

    var body = JSON.stringify(event);

    try {
      if (
        typeof window.navigator.sendBeacon === 'function' &&
        window.navigator.sendBeacon(
          endpoint,
          new Blob([body], {type: 'application/json'})
        )
      ) {
        return true;
      }
    } catch (error) {
      // Fall through to fetch.
    }

    if (typeof window.fetch !== 'function') return false;

    window
      .fetch(endpoint, {
        body: body,
        headers: {'Content-Type': 'application/json'},
        keepalive: true,
        method: 'POST',
      })
      .catch(function () {
        return undefined;
      });
    return true;
  };
})();
