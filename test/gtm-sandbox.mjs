// Stand-ins for the GTM sandbox APIs, so template.tpl's ___TESTS___ scenarios
// can run in Node without a GTM container. The Template Editor's Tests tab
// remains the source of truth.

import {readFileSync} from 'node:fs';

import {expect} from 'vitest';

export function readTemplate() {
  const text = readFileSync(
    new URL('../template.tpl', import.meta.url),
    'utf8',
  );
  const result = {};
  const marks = [...text.matchAll(/^___([A-Z_]+)___$/gm)];
  marks.forEach((mark, index) => {
    const start = mark.index + mark[0].length;
    const end = index + 1 < marks.length ? marks[index + 1].index : text.length;
    result[mark[1]] = text.slice(start, end).trim();
  });
  return result;
}

export function parseTests(yaml) {
  const scenarios = [];
  let setup = '';
  let current = null;
  let mode = null;

  for (const line of yaml.split('\n')) {
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

export function lintSandboxedJs(code) {
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
    generateRandom: (min, max) =>
      min + Math.floor(Math.random() * (max - min + 1)),
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

function assertThat(actual) {
  return {
    isEqualTo: (expected) => expect(actual).toStrictEqual(expected),
    isNotEqualTo: (expected) => expect(actual).not.toStrictEqual(expected),
    isUndefined: () => expect(actual).toBeUndefined(),
    isDefined: () => expect(actual).toBeDefined(),
    isTrue: () => expect(actual).toBe(true),
    isFalse: () => expect(actual).toBe(false),
    contains: (part) => expect(actual).toContain(part),
  };
}

function fail(message) {
  expect.fail(message);
}

export function runScenario(code, setup, scenario) {
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
    wasCalled: () =>
      expect(calls.has(name), `expected ${name} to be called`).toBe(true),
    wasNotCalled: () =>
      expect(calls.has(name), `expected ${name} not to be called`).toBe(false),
  });

  const mock = (name, impl) => {
    apis[name] = impl;
  };

  new Function(
    'mock',
    'mockObject',
    'runCode',
    'assertThat',
    'assertApi',
    'fail',
    `${setup}\n${scenario.code}`,
  )(mock, mock, runCode, assertThat, assertApi, fail);
}
