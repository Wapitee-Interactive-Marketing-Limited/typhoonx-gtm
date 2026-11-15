// Fails when the template, package version and metadata.yaml disagree in a
// way that would break a Gallery release. Needs full git history.

import {execFileSync} from 'node:child_process';
import {readFileSync} from 'node:fs';

import {HELPER_URL_PATTERN, ROOT, helperUrl, packageVersion} from './helper-url.mjs';
import {readMetadata} from './metadata.mjs';

const problems = [];
const version = packageVersion();
const expectedUrl = helperUrl(version);
const template = readFileSync(`${ROOT}/template.tpl`, 'utf8');

if (!template.includes(`const HELPER_URL = '${expectedUrl}';`)) {
  problems.push(`HELPER_URL in template.tpl must be ${expectedUrl} (run: node scripts/sync-helper-url.mjs)`);
}

const permissions = JSON.parse(
  template.match(/^___WEB_PERMISSIONS___$([\s\S]*?)^___/m)?.[1] ?? '[]',
);
const injectScript = permissions.find(
  (permission) => permission.instance.key.publicId === 'inject_script',
);
const allowedUrls =
  injectScript?.instance.param
    .find((param) => param.key === 'urls')
    ?.value.listItem.map((item) => item.string) ?? [];
if (allowedUrls.length !== 1 || allowedUrls[0] !== expectedUrl) {
  problems.push(`The inject_script permission must allow exactly ${expectedUrl}, not ${JSON.stringify(allowedUrls)}`);
}

for (const url of template.match(HELPER_URL_PATTERN) ?? []) {
  if (url !== expectedUrl) problems.push(`template.tpl still references ${url}`);
}

const git = (...args) => {
  try {
    execFileSync('git', args, {cwd: ROOT, stdio: 'ignore'});
    return true;
  } catch {
    return false;
  }
};

const metadata = readMetadata();
if (!metadata.homepage) problems.push('metadata.yaml needs a quoted homepage');
if (!metadata.documentation) problems.push('metadata.yaml needs a quoted documentation URL');
if (!metadata.hasVersions || metadata.shas.length === 0) {
  problems.push('metadata.yaml needs at least one entry under versions');
}

const seen = new Set();
for (const sha of metadata.shas) {
  if (!/^[0-9a-f]{40}$/.test(sha)) {
    problems.push(`metadata.yaml sha ${sha} is not a full 40-character commit SHA`);
    continue;
  }
  if (seen.has(sha)) problems.push(`metadata.yaml lists ${sha} twice`);
  seen.add(sha);

  if (!git('merge-base', '--is-ancestor', sha, 'HEAD')) {
    problems.push(`metadata.yaml sha ${sha} is not in this branch's history`);
  } else if (!git('cat-file', '-e', `${sha}:template.tpl`)) {
    problems.push(`metadata.yaml sha ${sha} has no template.tpl`);
  }
}

if (problems.length > 0) {
  problems.forEach((problem) => console.error(`✗ ${problem}`));
  process.exitCode = 1;
} else {
  console.log(`✓ Release metadata is consistent for v${version}`);
}
