import { hoverClassName } from '../components/NutritionLabel';

const rgbToHex = require('rgb-to-hex');
const transparent = 'rgba(0, 0, 0, 0)';

export default class CssConverter {
  constructor(activeSelector, rules) {
    this.activeSelector = activeSelector;
    this.rules = rules;
    this.computedStyles = this._getComputedStyles();
  }

  fontFamily() {
    if (this._hasRule('font-family')) return this.rules['font-family'];
    if (!this.computedStyles) return '';
    return this.computedStyles.fontFamily.split(', ')[0];
  }

  fontSize() {
    if (this._hasRule('font-size')) return this.rules['font-size'];
    if (!this.computedStyles) return '';
    return this.computedStyles.fontSize.replace('px', '');
  }

  fontColor() {
    if (this._hasRule('color')) return this.rules.color;
    if (!this.computedStyles) return '#000000';
    const rgbColor = this.computedStyles.color;
    return `#${rgbToHex(rgbColor)}`;
  }

  // it seems that the backgroundColor value in the computed styles works
  // differently than other computed styles. if an element has no explicit
  // background color set, it is considered to be transparent. to get the actual
  // background color as perceived by a user, we traverse up the DOM to find an
  // element with a non-transparent background color and return that.
  backgroundColor() {
    if (this._hasRule('background-color')) return this.rules['background-color'];
    if (!this.computedStyles) return '#ffffff';
    let rgbColor = this.computedStyles.backgroundColor;
    let targetElement = this.element;

    while (rgbColor === transparent && targetElement.parentElement) {
      targetElement = targetElement.parentElement;
      rgbColor = window.getComputedStyle(targetElement).backgroundColor;
    }
    return `#${rgbToHex(rgbColor)}`;
  }

  bold() {
    if (this._hasRule('bold')) return this.rules.bold;
    if (!this.computedStyles) return false;
    const fontWeight = this.computedStyles.fontWeight;
    return fontWeight === '700' || fontWeight === 'bold';
  }

  italic() {
    if (this._hasRule('italic')) return this.rules.italic;
    if (!this.computedStyles) return false;
    return this.computedStyles.fontStyle === 'italic';
  }

  strikethrough() {
    if (this._hasRule('strikethrough')) return this.rules.strikethrough;
    if (!this.computedStyles) return false;
    return this.computedStyles.textDecorationLine.includes('line-through');
  }

  underline() {
    if (this._hasRule('underline')) return this.rules.underline;
    if (!this.computedStyles) return false;
    return this.computedStyles.textDecorationLine.includes('underline');
  }

  _hasRule(property) {
    return typeof this.rules[property] !== 'undefined';
  }

  // here we temporarily remove the class that is added on hover to get the
  // styles with the "true" background color. we copy the styles because they
  // are otherwise live and will reflect when we add the hover class back.
  _getComputedStyles() {
    if (this.activeSelector) {
      let styles = {};
      this.element = document.querySelector(this.activeSelector);
      if (this.element.classList.contains(hoverClassName)) {
        this.element.classList.remove(hoverClassName);
        styles = Object.assign({}, window.getComputedStyle(this.element));
        this.element.classList.add(hoverClassName);
      } else {
        styles = Object.assign({}, window.getComputedStyle(this.element));
      }
      return styles;
    }
    return null;
  }
}
