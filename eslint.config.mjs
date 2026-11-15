import js from '@eslint/js';
import {defineConfig} from 'eslint/config';
import prettier from 'eslint-config-prettier/flat';
import simpleImportSort from 'eslint-plugin-simple-import-sort';
import globals from 'globals';

export default defineConfig(
  {
    files: ['**/*.{js,mjs}'],
    extends: [js.configs.recommended],
    languageOptions: {
      globals: globals.node,
    },
    plugins: {
      'simple-import-sort': simpleImportSort,
    },
    rules: {
      'no-restricted-syntax': [
        'error',
        {
          selector: 'ImportExpression',
          message:
            'Keep imports at the top of the module. Avoid inline dynamic import().',
        },
      ],
      'simple-import-sort/exports': 'error',
      'simple-import-sort/imports': 'error',
    },
  },
  {
    // Loaded by the tag in every browser, so it must stay ES5.
    files: ['helper/**/*.js'],
    languageOptions: {
      ecmaVersion: 5,
      globals: globals.browser,
      sourceType: 'script',
    },
    rules: {
      // ES5 has no optional catch binding.
      'no-unused-vars': ['error', {caughtErrors: 'none'}],
    },
  },
  // Formatting is Prettier's job. Keep last so it wins over the configs above.
  prettier,
);
