const textDecorationKeys = ['strikethrough', 'underline'];

export default class CssSelectorWriter {
  // @param {string} selector - a CSS selector
  // @param {object} rules - an object where keys are CSS-ish property names and
  //   values are CSS property values. note that the keys do not all map onto
  //   CSS property names because they map onto UI controls instead and there
  //   are multiple controls which may be for the same CSS property name.
  constructor(selector, rules) {
    this.selector = selector;
    this.rules = rules;
  }

  cssString() {
    let rulesString = '';
    Object.entries(this.rules).forEach(
      ([key, value]) => {
        if (!textDecorationKeys.includes(key)) {
          rulesString += this.ruleString(key, value);
        }
      }
    );
    rulesString += this.textDecorationString();
    return `${this.selector} { ${rulesString} }`;
  }

  ruleString(key, value) {
    return `${this.keyValueString(key, value)} !important;\n`;
  }

  keyValueString(key, value) {
    switch (key) {
      case 'fontFamily':
        return `font-family: "${value}"`;
      case 'fontSize':
        return `font-size: ${value}px`;
      case 'bold':
        return `font-weight: ${value ? 'bold' : 'normal'}`;
      case 'italic':
        return `font-style: ${value ? 'italic' : 'normal'}`;
      default:
        return `${this.camelCaseToHyphen(key)}: ${value}`;
    }
  }

  textDecorationString() {
    let valueString = '';
    if (this.rules.strikethrough) valueString += 'line-through';
    if (this.rules.underline) valueString += ' underline';
    return `text-decoration: ${valueString} !important\n`;
  }

  camelCaseToHyphen(key) {
    return key.replace(/([a-z][A-Z])/g, (g) => `${g[0]}-${g[1].toLowerCase()}`);
  }
}
