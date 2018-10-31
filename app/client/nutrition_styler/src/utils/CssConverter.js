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
    if (this.rules['font-family']) return this.rules['font-family'];
    if (!this.computedStyles) return '';
    return this.computedStyles.fontFamily.split(', ')[0];
  }

  fontSize() {
    if (this.rules['font-size']) return this.rules['font-size'];
    if (!this.computedStyles) return '';
    return this.computedStyles.fontSize.replace('px', '');
  }

  fontColor() {
    if (this.rules['font-color']) return this.rules['font-color'];
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
    if (this.rules['background-color']) return this.rules['background-color'];
    if (!this.computedStyles) return '#ffffff';
    let rgbColor = this.computedStyles.backgroundColor;
    let targetElement = this.element;

    while (rgbColor === transparent && targetElement.parentElement) {
      targetElement = targetElement.parentElement;
      rgbColor = window.getComputedStyle(targetElement).backgroundColor;
    }

    return `#${rgbToHex(rgbColor)}`;
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
