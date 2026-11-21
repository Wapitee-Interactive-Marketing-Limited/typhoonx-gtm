import {describe, expect, test} from 'vitest';

import {
  lintSandboxedJs,
  parseTests,
  readTemplate,
  runScenario,
} from './gtm-sandbox.mjs';

const sections = readTemplate();
const code = sections.SANDBOXED_JS_FOR_WEB_TEMPLATE;
const {scenarios, setup} = parseTests(sections.TESTS);

describe('template.tpl', () => {
  test.each(['INFO', 'TEMPLATE_PARAMETERS', 'WEB_PERMISSIONS'])(
    '___%s___ is valid JSON',
    (name) => {
      expect(() => JSON.parse(sections[name])).not.toThrow();
    },
  );

  test('sandboxed JS only uses syntax GTM supports', () => {
    expect(lintSandboxedJs(code)).toStrictEqual([]);
  });

  test('___TESTS___ only uses syntax GTM supports', () => {
    expect(lintSandboxedJs(setup)).toStrictEqual([]);
    scenarios.forEach((scenario) => {
      expect(lintSandboxedJs(scenario.code), scenario.name).toStrictEqual([]);
    });
  });

  test('___TESTS___ has scenarios', () => {
    expect(scenarios.length).toBeGreaterThan(0);
  });
});

describe('lintSandboxedJs', () => {
  test.each([
    'x += 1;',
    'x -= 1;',
    'x *= 2;',
    'x /= 2;',
    'x %= 2;',
    'x **= 2;',
    'x <<= 1;',
    'x >>= 1;',
    'x >>>= 1;',
    'x &= 1;',
    'x |= 1;',
    'x ^= 1;',
    'x &&= y;',
    'x ||= y;',
    'x ??= y;',
    'const y = a?.b;',
    'const y = a ?? b;',
    'const y = a ** 2;',
    'const f = async () => await g();',
    'function* g() { yield 1; }',
    'const s = `a${b}`;',
    'const y = [...a];',
    'const r = /a+/;',
  ])('rejects %s', (line) => {
    expect(lintSandboxedJs(line)).not.toStrictEqual([]);
  });

  test.each([
    'x = x + 1;',
    'if (a === b || a !== c || a <= b || a >= c || a == b || a != c) f();',
    'for (let i = 0; i < n; i++) f(i);',
    'const f = (a) => (a ? 1 : 0.5);',
    "log('x += 1 ?? `y` ...');",
    'log("x -= 1");',
    'x = 1; // x += 1',
  ])('accepts %s', (line) => {
    expect(lintSandboxedJs(line)).toStrictEqual([]);
  });
});

describe('___TESTS___', () => {
  test.each(scenarios)('$name', (scenario) => {
    runScenario(code, setup, scenario);
  });
});
