// Adds a commit to metadata.yaml as a Gallery release, with the version's
// CHANGELOG.md entry as its change notes. Does nothing if it is already listed.
//
// Usage: node scripts/release-to-gallery.mjs [--sha <commit>] [--version <x.y.z>] [--notes-file <path>]
// --sha defaults to HEAD and --version to package.json's version.
// --notes-file also writes the CHANGELOG entry there, for the GitHub Release.

import {execFileSync} from 'node:child_process';
import {readFileSync, writeFileSync} from 'node:fs';
import {parseArgs} from 'node:util';

import {packageVersion, ROOT} from './helper-url.mjs';
import {addVersion, readMetadata} from './metadata.mjs';

const {values} = parseArgs({
  options: {
    'notes-file': {type: 'string'},
    sha: {type: 'string'},
    version: {type: 'string'},
  },
});

const version = values.version ?? packageVersion();
const sha = execFileSync(
  'git',
  ['rev-parse', '--verify', `${values.sha ?? 'HEAD'}^{commit}`],
  {
    cwd: ROOT,
    encoding: 'utf8',
  },
).trim();

const changelog = readFileSync(`${ROOT}/CHANGELOG.md`, 'utf8');
const section = changelog
  .match(
    new RegExp(
      `^## ${version.replaceAll('.', '\\.')}$([\\s\\S]*?)(?=^## |(?![\\s\\S]))`,
      'm',
    ),
  )?.[1]
  .trim();
if (!section) {
  throw new Error(`CHANGELOG.md has no "## ${version}" entry`);
}

const noteLines = section
  .split('\n')
  .filter((line) => line.trim() !== '' && !line.startsWith('#'))
  .map((line) => line.replace(/^- [0-9a-f]{7,40}: /, '- '));

if (readMetadata().shas.includes(sha)) {
  console.log(`metadata.yaml already lists ${sha}`);
} else {
  addVersion(sha, noteLines);
  console.log(`metadata.yaml now releases v${version} at ${sha}`);
}

if (values['notes-file']) writeFileSync(values['notes-file'], `${section}\n`);
