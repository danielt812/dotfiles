module.exports = {
  extends: "eslint:recommended",
  env: {
    node: true,
    browser: true,
  },
  parserOptions: {
    ecmaVersion: 12,
  },
  rules: {
    indent: ["warn", 2],
    quotes: ["warn", "double"],
    semi: ["error", "always"],
  },
};
