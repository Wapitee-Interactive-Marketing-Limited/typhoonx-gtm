import {readFileSync} from 'node:fs';
import {fileURLToPath} from 'node:url';

export const ROOT = fileURLToPath(new URL('..', import.meta.url));

const PREFIX =
  'https://cdn.jsdelivr.net/gh/Wapitee-Interactive-Marketing-Limited/typhoonx-gtm@';
const SUFFIX = '/helper/typhoonx-gtm.js';

/** Every jsDelivr helper URL in a file, whatever tag it is pinned to. */
export const HELPER_URL_PATTERN =
  /https:\/\/cdn\.jsdelivr\.net\/gh\/Wapitee-Interactive-Marketing-Limited\/typhoonx-gtm@[^/'"\s]+\/helper\/typhoonx-gtm\.js/g;

export function helperUrl(version) {
  return `${PREFIX}v${version}${SUFFIX}`;
}

export function packageVersion() {
  return JSON.parse(readFileSync(`${ROOT}/package.json`, 'utf8')).version;
}
