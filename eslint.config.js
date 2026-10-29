import js from '@eslint/js';

export default [
  { ignores: ['dist/', 'node_modules/'] },
  js.configs.recommended,
  {
    languageOptions: {
      ecmaVersion: 2023,
      sourceType: 'module',
      globals: { console: 'readonly', process: 'readonly', URL: 'readonly' },
    },
  },
];
