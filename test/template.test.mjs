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

  test('___TESTS___ has scenarios', () => {
    expect(scenarios.length).toBeGreaterThan(0);
  });
});

describe('___TESTS___', () => {
  test.each(scenarios)('$name', (scenario) => {
    runScenario(code, setup, scenario);
  });
});
