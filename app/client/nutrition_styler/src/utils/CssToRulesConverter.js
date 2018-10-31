const rgbToHex = require('rgb-to-hex');
const transparent = 'rgba(0, 0, 0, 0)';

export default class CssToRulesConverter {
  constructor(activeSelector) {
    this.activeSelector = activeSelector;
    this.element = document.querySelector(this.activeSelector);
    this.computedStyles = window.getComputedStyle(this.element);
  }

  rules() {
    return {
      fontFamily: this.computedStyles.fontFamily.split(', ')[0],
      fontSize: this.computedStyles.fontSize.replace('px', ''),
      color: this._getColor(),
      backgroundColor: this._getBackgroundColor(),
      bold: this._getBold(),
      italic: this.computedStyles.fontStyle === 'italic',
      strikethrough: this.computedStyles.textDecorationLine.includes('line-through'),
      underline: this.computedStyles.textDecorationLine.includes('underline')
    };
  }

  _getColor() {
    const rgbColor = this.computedStyles.color;
    return `#${rgbToHex(rgbColor)}`;
  }

  // it seems that the `backgroundColor` value in the computed styles works
  // differently than other computed styles. if an element has no explicit
  // background color set, it is considered to be transparent. to get the actual
  // background color as shown on the screen, we traverse up the DOM to find an
  // a non-transparent background color on an ancestor and return that.
  _getBackgroundColor() {
    let rgbColor = this.computedStyles.backgroundColor;
    let targetElement = this.element;

    while (rgbColor === transparent && targetElement.parentElement) {
      targetElement = targetElement.parentElement;
      rgbColor = window.getComputedStyle(targetElement).backgroundColor;
    }
    return `#${rgbToHex(rgbColor)}`;
  }

  _getBold() {
    const fontWeight = this.computedStyles.fontWeight;
    return fontWeight === '700' || fontWeight === 'bold';
  }
}
