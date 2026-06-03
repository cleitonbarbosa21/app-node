import js from '@eslint/js';

export default [
  js.configs.recommended,
  {
    rules: {
      // Transformar erros em warnings
      'no-unused-vars': 'warn',
      'no-console': 'warn',
      
      // Desabilitar regras específicas
      'no-undef': 'off',
      'react/prop-types': 'off',
    }
  }
];