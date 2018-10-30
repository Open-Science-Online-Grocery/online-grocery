import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import { Button, Icon, Select } from 'semantic-ui-react';

const fontOptions = [
  { text: 'Arial', value: 'Arial' },
  { text: 'Helvetica', value: 'Helvetica' },
  { text: 'Times New Roman', value: 'Time New Roman' },
  { text: 'Courier', value: 'Courier' },
  { text: 'Veranda', value: 'Veranda' },
  { text: 'Georgia', value: 'Georgia' },
  { text: 'Palatino', value: 'Palatino' },
  { text: 'Garamond', value: 'Garamond' },
  { text: 'Comic Sans MS', value: 'Comic Sans MS' },
  { text: 'Trebuchet MS', value: 'Trebuchet MS' },
  { text: 'Arial Black', value: 'Arial Black' },
  { text: 'Impact', value: 'Impact' }
];

export default class StylerForm extends PureComponent {
  constructor(props) {
    super(props);
  }

  getComputedStyles() {
    if (this.props.activeSelector) {
      const element = document.querySelector(this.props.activeSelector);
      return window.getComputedStyle(element);
    }
    return null;
  }

  getCurrentFontFamily() {
    if (!this.computedStyles) return null;
    return this.computedStyles['font-family'].split(', ')[0];
  }

  isDisabled() {
    return !this.props.activeSelector;
  }

  disabledClass() {
    return this.isDisabled() ? 'disabled' : '';
  }

  render() {
    this.computedStyles = this.getComputedStyles();
    return (
      <React.Fragment>
        <p className={this.props.activeSelector ? 'disabled' : ''}>To change nutrition label styling, click part of the label to the left.</p>
        <div className={`ui segment ${this.disabledClass()}`}>
          <div className="fields">
            <div className="ten wide field">
              <label htmlFor="font-family">Font</label>
              <Select
                id="font-family"
                options={fontOptions}
                disabled={this.isDisabled()}
                value={this.getCurrentFontFamily()}
              />
            </div>
            <div className="six wide field">
              <label htmlFor="font-size">Font size</label>
              <input id="font-size" type="number" value="8" min="1" />
            </div>
          </div>
          <div className="fields">
            <div className="four wide field">
              <label htmlFor="font-color">Text color</label>
              <input id="font-color" type="color" value={this.computedStyles ? this.computedStyles.color : '#000000'} />
            </div>
            <div className="four wide field">
              <label htmlFor="background-color">Background color</label>
              <input id="background-color" type="color" value="#ffffff" />
            </div>
            <div className="eight wide field">
              <label htmlFor="text-style">Text style</label>
              <div id="text-style" className="ui icon buttons">
                <button type="button" className="ui button"><i className="bold icon" /></button>
                <button type="button" className="ui button"><i className="italic icon" /></button>
                <button type="button" className="ui button active"><i className="strikethrough icon" /></button>
                <button type="button" className="ui button"><i className="underline icon" /></button>
              </div>
            </div>
          </div>
        </div>
        <div className="actions">
          <span>Remove all formating on:</span>
          <Button disabled={this.isDisabled()} type="button">
            <Icon name="undo" />
            Current Selection
          </Button>
          <Button type="button">
            <Icon name="undo" />
            Entire Label
          </Button>
        </div>
      </React.Fragment>
    );
  }
}

StylerForm.propTypes = {
  activeSelector: PropTypes.string
};

StylerForm.defaultProps = {
  activeSelector: null
};
