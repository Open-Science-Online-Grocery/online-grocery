import CssSelectorWriter from './CssSelectorWriter';

export default class CssWriter {
  constructor(rulesBySelector) {
    this.rulesBySelector = rulesBySelector;
  }

  cssString() {
    return Object.entries(this.rulesBySelector).map(([selector, ruleObject]) => (
      new CssSelectorWriter(selector, ruleObject.rules || {}).cssString()
    )).join(' ');
  }
}
