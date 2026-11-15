export default {
  arrowParens: 'always',
  printWidth: 80,
  semi: true,
  singleQuote: true,
  bracketSpacing: false,
  trailingComma: 'all',
  overrides: [
    {
      // Runs as-is in every browser that loads the tag, so it stays ES5.
      files: 'helper/**/*.js',
      options: {trailingComma: 'es5'},
    },
    {
      // Matches the Gallery's examples and what scripts/metadata.mjs writes.
      files: 'metadata.yaml',
      options: {singleQuote: false},
    },
  ],
};
