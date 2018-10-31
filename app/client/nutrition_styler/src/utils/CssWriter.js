export default class CssWriter {
  // @param {string} selector - a CSS selector
  // @param {object} rules - an object where keys are CSS property names and
  //   values are CSS property values
  constructor(selector, rules) {
    this.selector = selector;
    this.rules = rules;
  }

  cssString() {
    let rulesString = '';
    Object.entries(this.rules).forEach(
      ([key, value]) => rulesString +=
        `${this.convertKey(key)}: ${this.convertValue(key, value)} !important;\n`
    );
    return `${this.selector} { ${rulesString} }`;
  }

  convertKey(key) {
    switch (key) {
      case 'font-color':
        return 'color';
      default:
        return key;
    }
  }

  convertValue(key, value) {
    switch (key) {
      case 'font-size':
        return `${value}px`;
      default:
        return value;
    }
  }
}
