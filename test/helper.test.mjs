import {readFileSync} from 'node:fs';

import {describe, expect, test, vi} from 'vitest';

const source = readFileSync(
  new URL('../helper/typhoonx-gtm.js', import.meta.url),
  'utf8',
);

const ENDPOINT = 'https://spell.typhoonx.io/api/v1/receive';
const USER_AGENT = 'Mozilla/5.0 (test)';

function loadHelper({sendBeacon, fetch} = {}) {
  const window = {navigator: {userAgent: USER_AGENT}};
  if (sendBeacon) window.navigator.sendBeacon = vi.fn(sendBeacon);
  if (fetch) window.fetch = vi.fn(fetch);
  new Function('window', source)(window);
  return window;
}

describe('typhoonxGtmSend', () => {
  test('keeps an existing sender when loaded twice', () => {
    const window = {navigator: {userAgent: USER_AGENT}};
    const existing = () => true;
    window.typhoonxGtmSend = existing;

    new Function('window', source)(window);

    expect(window.typhoonxGtmSend).toBe(existing);
  });

  test('sends a JSON beacon with the user agent added', async () => {
    const window = loadHelper({
      sendBeacon: () => true,
      fetch: () => Promise.resolve(),
    });
    const payload = {event_type: 'page_view', merchant_id: 'TPX-1'};

    expect(window.typhoonxGtmSend(ENDPOINT, payload)).toBe(true);

    expect(window.navigator.sendBeacon).toHaveBeenCalledOnce();
    const [url, blob] = window.navigator.sendBeacon.mock.calls[0];
    expect(url).toBe(ENDPOINT);
    expect(blob.type).toBe('application/json');
    expect(JSON.parse(await blob.text())).toStrictEqual({
      event_type: 'page_view',
      merchant_id: 'TPX-1',
      user_agent: USER_AGENT,
    });
    expect(payload).toStrictEqual({
      event_type: 'page_view',
      merchant_id: 'TPX-1',
    });
    expect(window.fetch).not.toHaveBeenCalled();
  });

  test.each([
    ['is missing', undefined],
    ['is not queued', () => false],
    [
      'throws',
      () => {
        throw new TypeError('Illegal invocation');
      },
    ],
  ])('falls back to a keepalive fetch when sendBeacon %s', (_, sendBeacon) => {
    const window = loadHelper({sendBeacon, fetch: () => Promise.resolve()});

    expect(window.typhoonxGtmSend(ENDPOINT, {event_type: 'view_cart'})).toBe(
      true,
    );

    expect(window.fetch).toHaveBeenCalledExactlyOnceWith(ENDPOINT, {
      body: JSON.stringify({event_type: 'view_cart', user_agent: USER_AGENT}),
      headers: {'Content-Type': 'application/json'},
      keepalive: true,
      method: 'POST',
    });
  });

  // Vitest fails the run on an unhandled rejection. fetch is not a vi.fn here
  // because a mock tracks its promise's result, which handles the rejection.
  test('swallows a failed fetch', async () => {
    const window = loadHelper();
    window.fetch = () => Promise.reject(new TypeError('Failed to fetch'));

    expect(window.typhoonxGtmSend(ENDPOINT, {event_type: 'search'})).toBe(true);
    await new Promise((resolve) => setTimeout(resolve, 0));
  });

  test('reports failure when neither sendBeacon nor fetch exists', () => {
    const window = loadHelper();

    expect(window.typhoonxGtmSend(ENDPOINT, {event_type: 'page_view'})).toBe(
      false,
    );
  });
});
