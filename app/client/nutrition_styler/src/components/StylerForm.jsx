import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import { Button, Icon, Select } from 'semantic-ui-react';

const fontOptions = [
  { text: 'Arial', value: 'Arial' },
  { text: 'Helvetica', value: 'Helvetica' },
  { text: 'Times New Roman', value: 'Times New Roman' },
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
    this.handleSelectChange = (event, data) => {
      this.props.setStyle(this.props.activeSelector, data.id, data.value);
    };
    this.handleInputChange = (event) => {
      this.props.setStyle(
        this.props.activeSelector,
        event.currentTarget.id,
        event.currentTarget.value
      );
    };
    this.handleButtonChange = (event) => {
      this.props.setStyle(
        this.props.activeSelector,
        event.currentTarget.id,
        !event.currentTarget.classList.contains('active')
      );
    };
    this.handleResetSelection = () => {
      this.props.resetSelection(this.props.activeSelector);
    };
  }

  disabledClass() {
    return this.props.disabled ? 'disabled' : '';
  }

  render() {
    return (
      <>
        <p className={this.props.disabled ? '' : 'disabled'}>
          To change nutrition label styling, click part of the label to the left.
        </p>
        <input type="hidden" name="condition[nutrition_styles]" value={this.props.inputValue} />
        <div className={`ui segment ${this.disabledClass()}`}>
          <div className="fields">
            <div className="ten wide field">
              <label htmlFor="fontFamily">Font</label>
              <Select
                id="fontFamily"
                options={fontOptions}
                disabled={this.props.disabled}
                value={this.props.fontFamily}
                onChange={this.handleSelectChange}
              />
            </div>
            <div className="six wide field">
              <label htmlFor="fontSize">Font size</label>
              <input id="fontSize" type="number" value={this.props.fontSize} min="1" onChange={this.handleInputChange} />
            </div>
          </div>
          <div className="fields">
            <div className="four wide field">
              <label htmlFor="color">Text color</label>
              <input id="color" type="color" value={this.props.fontColor} onChange={this.handleInputChange} />
            </div>
            <div className="four wide field">
              <label htmlFor="backgroundColor">Background color</label>
              <input id="backgroundColor" type="color" value={this.props.backgroundColor} onChange={this.handleInputChange} />
            </div>
            <div className="eight wide field">
              <label htmlFor="text-style">Text style</label>
              <div id="text-style" className="ui icon buttons">
                <Button
                  icon
                  type="button"
                  id="bold"
                  className={`ui button ${this.props.bold ? 'active' : ''}`}
                  onClick={this.handleButtonChange}
                >
                  <Icon name="bold" />
                </Button>
                <Button
                  icon
                  type="button"
                  id="italic"
                  className={`ui button ${this.props.italic ? 'active' : ''}`}
                  onClick={this.handleButtonChange}
                >
                  <Icon name="italic" />
                </Button>
                <Button
                  icon
                  type="button"
                  id="strikethrough"
                  className={`ui button ${this.props.strikethrough ? 'active' : ''}`}
                  onClick={this.handleButtonChange}
                >
                  <Icon name="strikethrough" />
                </Button>
                <Button
                  icon
                  type="button"
                  id="underline"
                  className={`ui button ${this.props.underline ? 'active' : ''}`}
                  onClick={this.handleButtonChange}
                >
                  <Icon name="underline" />
                </Button>
              </div>
            </div>
          </div>
        </div>
        <div className="actions">
          <span>Remove all formating on:</span>
          <Button disabled={this.props.disabled} type="button" onClick={this.handleResetSelection}>
            <Icon name="remove" />
            Current Selection
          </Button>
          <Button type="button" onClick={this.props.resetAll}>
            <Icon name="remove" />
            Entire Label
          </Button>
        </div>
      </>
    );
  }
}

StylerForm.propTypes = {
  inputValue: PropTypes.string,
  activeSelector: PropTypes.string,
  disabled: PropTypes.bool.isRequired,
  fontFamily: PropTypes.string,
  fontSize: PropTypes.string,
  fontColor: PropTypes.string,
  backgroundColor: PropTypes.string,
  bold: PropTypes.bool,
  italic: PropTypes.bool,
  strikethrough: PropTypes.bool,
  underline: PropTypes.bool,
  setStyle: PropTypes.func.isRequired,
  resetSelection: PropTypes.func.isRequired,
  resetAll: PropTypes.func.isRequired
};

StylerForm.defaultProps = {
  inputValue: null,
  activeSelector: null,
  fontFamily: null,
  fontSize: '',
  fontColor: '#000000',
  backgroundColor: '#ffffff',
  bold: false,
  italic: false,
  strikethrough: false,
  underline: false
};
