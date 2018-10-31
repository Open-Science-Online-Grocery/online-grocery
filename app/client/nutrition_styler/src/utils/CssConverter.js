const rgbToHex = require('rgb-to-hex');

export default class CssConverter {
  constructor(activeSelector) {
    this.activeSelector = activeSelector;
    this.computedStyles = this._getComputedStyles();
  }

  fontFamily() {
    if (!this.computedStyles) return '';
    return this.computedStyles.fontFamily.split(', ')[0];
  }

  fontSize() {
    if (!this.computedStyles) return '';
    return this.computedStyles.fontSize.replace('px', '');
  }

  fontColor() {
    if (!this.computedStyles) return '#000000';
    const rgbColor = this.computedStyles.color;
    return `#${rgbToHex(rgbColor)}`;
  }

  backgroundColor() {
    if (!this.computedStyles) return '#ffffff';
    const rgbColor = this.computedStyles.backgroundColor;
    return `#${rgbToHex(rgbColor)}`;
  }

  _getComputedStyles() {
    if (this.activeSelector) {
      const element = document.querySelector(this.activeSelector);
      return window.getComputedStyle(element);
    }
    return null;
  }
}
