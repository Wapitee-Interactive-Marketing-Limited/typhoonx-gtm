import {readFileSync, writeFileSync} from 'node:fs';

import {ROOT} from './helper-url.mjs';

const PATH = `${ROOT}/metadata.yaml`;

/** The fields of metadata.yaml the Template Gallery reads. */
export function readMetadata() {
  const text = readFileSync(PATH, 'utf8');
  const field = (name) => text.match(new RegExp(`^${name}: "(.+)"$`, 'm'))?.[1];

  return {
    documentation: field('documentation'),
    hasVersions: /^versions:$/m.test(text),
    homepage: field('homepage'),
    shas: [...text.matchAll(/^ {2}- sha: (\S+)$/gm)].map((match) => match[1]),
    text,
  };
}

/** Adds a release to the top of `versions`, newest first as the Gallery requires. */
export function addVersion(sha, noteLines) {
  const {text} = readMetadata();
  const entry = [
    `  - sha: ${sha}`,
    '    changeNotes: |2',
    ...noteLines.map((line) => `      ${line}`),
  ].join('\n');

  writeFileSync(PATH, text.replace(/^versions:\n/m, `versions:\n${entry}\n`));
}
