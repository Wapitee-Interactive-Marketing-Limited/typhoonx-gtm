// Runs template.tpl's ___TESTS___ scenarios in Node against stand-ins for the
// GTM sandbox APIs, so the template can be checked without a GTM container.
// The Template Editor's Tests tab remains the source of truth.
//
// Usage: node test/run-template-tests.mjs

import {readFileSync} from 'node:fs';
import {fileURLToPath} from 'node:url';
import {isDeepStrictEqual, inspect} from 'node:util';

const templatePath = fileURLToPath(new URL('../template.tpl', import.meta.url));
const template = readFileSync(templatePath, 'utf8');

function sections(text) {
  const result = {};
  const pattern = /^___([A-Z_]+)___$/gm;
  const marks = [...text.matchAll(pattern)];
  marks.forEach((mark, index) => {
    const start = mark.index + mark[0].length;
    const end = index + 1 < marks.length ? marks[index + 1].index : text.length;
    result[mark[1]] = text.slice(start, end).trim();
  });
  return result;
}

function parseTests(yaml) {
  const lines = yaml.split('\n');
  const scenarios = [];
  let setup = '';
  let current = null;
  let mode = null;

  for (const line of lines) {
    const name = line.match(/^- name: (.+)$/);
    if (name) {
      current = {name: name[1], code: []};
      scenarios.push(current);
      mode = null;
      continue;
    }
    if (/^ {2}code: \|-$/.test(line)) {
      mode = 'code';
      continue;
    }
    if (/^setup: \|-$/.test(line)) {
      mode = 'setup';
      continue;
    }
    if (mode === 'code') current.code.push(line.replace(/^ {4}/, ''));
    if (mode === 'setup') setup += line.replace(/^ {2}/, '') + '\n';
  }

  return {
    scenarios: scenarios.map((s) => ({name: s.name, code: s.code.join('\n')})),
    setup,
  };
}

const UNSUPPORTED_SYNTAX = [
  [/`/, 'template literal'],
  [/\.\.\./, 'spread or rest syntax'],
  [/\btypeof\b/, 'typeof'],
  [/\bnew\s+[A-Z]/, 'new'],
  [/\bclass\s/, 'class'],
  [/\bfor\s*\([^)]*\bof\b/, 'for...of'],
  [/\bfor\s*\([^)]*\bin\b/, 'for...in'],
  [/[=(,:]\s*\/[^/*]/, 'regular expression literal'],
  [/\bDate\b/, 'Date'],
  [/\bwindow\b|\bdocument\b|\bnavigator\b/, 'browser global'],
];

function lintSandboxedJs(code) {
  const problems = [];
  code.split('\n').forEach((line, index) => {
    const withoutStrings = line
      .replace(/'(?:[^'\\]|\\.)*'/g, "''")
      .replace(/\/\/.*$/, '');
    for (const [pattern, label] of UNSUPPORTED_SYNTAX) {
      if (pattern.test(withoutStrings)) {
        problems.push(`line ${index + 1}: ${label}: ${line.trim()}`);
      }
    }
  });
  return problems;
}

function gtmType(value) {
  if (value === null) return 'null';
  if (Array.isArray(value)) return 'array';
  return typeof value;
}

function sandboxApis() {
  const storage = () => {
    const values = new Map();
    return {
      getItem: (key) => (values.has(key) ? values.get(key) : null),
      setItem: (key, value) => {
        values.set(key, value);
        return true;
      },
      removeItem: (key) => values.delete(key),
      clear: () => values.clear(),
    };
  };

  return {
    JSON,
    Math,
    Object: {
      keys: Object.keys,
      values: Object.values,
      entries: Object.entries,
      freeze: Object.freeze,
    },
    callInWindow: () => undefined,
    copyFromDataLayer: () => undefined,
    generateRandom: (min, max) => min + Math.floor(Math.random() * (max - min + 1)),
    getCookieValues: () => [],
    getQueryParameters: () => undefined,
    getReferrerUrl: () => '',
    getTimestampMillis: () => Date.now(),
    getType: gtmType,
    getUrl: () => 'https://example.com/',
    injectScript: (url, onSuccess) => onSuccess(),
    isConsentGranted: () => true,
    localStorage: storage(),
    logToConsole: () => undefined,
    makeInteger: (value) => Math.trunc(Number(value)),
    makeNumber: (value) => Number(value),
    makeString: (value) => String(value),
    readAnalyticsStorage: () => ({client_id: undefined, sessions: []}),
    setCookie: () => undefined,
    templateStorage: storage(),
  };
}

class AssertionError extends Error {}

function fail(message) {
  throw new AssertionError(message);
}

function assertThat(actual) {
  const show = (value) => inspect(value, {depth: 6});
  return {
    isEqualTo: (expected) =>
      isDeepStrictEqual(actual, expected) ||
      fail(`expected ${show(actual)} to equal ${show(expected)}`),
    isNotEqualTo: (expected) =>
      !isDeepStrictEqual(actual, expected) ||
      fail(`expected ${show(actual)} not to equal ${show(expected)}`),
    isUndefined: () =>
      actual === undefined || fail(`expected ${show(actual)} to be undefined`),
    isDefined: () =>
      actual !== undefined || fail('expected value to be defined'),
    isTrue: () => actual === true || fail(`expected ${show(actual)} to be true`),
    isFalse: () =>
      actual === false || fail(`expected ${show(actual)} to be false`),
    contains: (part) =>
      actual.includes(part) || fail(`expected ${show(actual)} to contain ${show(part)}`),
  };
}

function runScenario(code, setup, scenario) {
  const apis = sandboxApis();
  const calls = new Map();
  const record = (name) => calls.set(name, (calls.get(name) ?? 0) + 1);

  const require = (name) => {
    if (!(name in apis)) throw new Error(`require('${name}') is not stubbed`);
    const api = apis[name];
    if (typeof api !== 'function') return api;
    return (...args) => {
      record(name);
      return apis[name](...args);
    };
  };

  const runCode = (data) => {
    const run = new Function('require', 'data', code);
    run(require, {
      ...data,
      gtmOnSuccess: () => record('gtmOnSuccess'),
      gtmOnFailure: () => record('gtmOnFailure'),
    });
  };

  const assertApi = (name) => ({
    wasCalled: () => calls.has(name) || fail(`expected ${name} to be called`),
    wasNotCalled: () =>
      !calls.has(name) || fail(`expected ${name} not to be called`),
  });

  const testBody = `${setup}\n${scenario.code}`;
  new Function(
    'mock',
    'mockObject',
    'runCode',
    'assertThat',
    'assertApi',
    'fail',
    testBody,
  )(
    (name, impl) => {
      apis[name] = impl;
    },
    (name, impl) => {
      apis[name] = impl;
    },
    runCode,
    assertThat,
    assertApi,
    fail,
  );
}

const parts = sections(template);
let failures = 0;

for (const name of ['INFO', 'TEMPLATE_PARAMETERS', 'WEB_PERMISSIONS']) {
  try {
    JSON.parse(parts[name]);
  } catch (error) {
    failures += 1;
    console.error(`✗ ___${name}___ is not valid JSON: ${error.message}`);
  }
}

const code = parts.SANDBOXED_JS_FOR_WEB_TEMPLATE;
const lint = lintSandboxedJs(code);
if (lint.length > 0) {
  failures += 1;
  console.error('✗ Sandboxed JS uses unsupported syntax:');
  lint.forEach((problem) => console.error(`    ${problem}`));
}

const {scenarios, setup} = parseTests(parts.TESTS);
for (const scenario of scenarios) {
  try {
    runScenario(code, setup, scenario);
    console.log(`✓ ${scenario.name}`);
  } catch (error) {
    failures += 1;
    console.error(`✗ ${scenario.name}\n    ${error.message}`);
  }
}

console.log(`\n${scenarios.length} scenarios, ${failures} failure(s)`);
process.exitCode = failures > 0 ? 1 : 0;
