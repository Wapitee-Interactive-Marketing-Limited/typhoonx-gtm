// Adds HEAD to metadata.yaml as the release of package.json's version, with
// that version's CHANGELOG.md entry as its Gallery change notes.
//
// Usage: node scripts/release-to-gallery.mjs [--notes-file <path>]
// --notes-file also writes the CHANGELOG entry there, for the GitHub Release.

import {execFileSync} from 'node:child_process';
import {readFileSync, writeFileSync} from 'node:fs';
import {parseArgs} from 'node:util';

import {ROOT, packageVersion} from './helper-url.mjs';
import {addVersion, readMetadata} from './metadata.mjs';

const {values} = parseArgs({options: {'notes-file': {type: 'string'}}});

const version = packageVersion();
const sha = execFileSync('git', ['rev-parse', 'HEAD'], {cwd: ROOT, encoding: 'utf8'}).trim();

const changelog = readFileSync(`${ROOT}/CHANGELOG.md`, 'utf8');
const section = changelog.match(
  new RegExp(`^## ${version.replaceAll('.', '\\.')}$([\\s\\S]*?)(?=^## |(?![\\s\\S]))`, 'm'),
)?.[1].trim();
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
