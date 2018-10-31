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
        `${key}: ${this.convertValue(key, value)} !important;\n`
    );
    return `${this.selector} { ${rulesString} }`;
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
