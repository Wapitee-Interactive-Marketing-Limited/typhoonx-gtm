// Pins template.tpl's helper URL (sandboxed code, inject_script permission
// and tests) to the tag of the version in package.json.

import {readFileSync, writeFileSync} from 'node:fs';

import {HELPER_URL_PATTERN, ROOT, helperUrl, packageVersion} from './helper-url.mjs';

const path = `${ROOT}/template.tpl`;
const template = readFileSync(path, 'utf8');
const url = helperUrl(packageVersion());
const synced = template.replace(HELPER_URL_PATTERN, url);

if (synced === template) {
  console.log(`template.tpl already loads ${url}`);
} else {
  writeFileSync(path, synced);
  console.log(`template.tpl now loads ${url}`);
}
