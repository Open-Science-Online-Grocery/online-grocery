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
  }

  disabledClass() {
    return this.props.disabled ? 'disabled' : '';
  }

  render() {
    return (
      <React.Fragment>
        <p className={this.disabledClass()}>
          To change nutrition label styling, click part of the label to the left.
        </p>
        <div className={`ui segment ${this.disabledClass()}`}>
          <div className="fields">
            <div className="ten wide field">
              <label htmlFor="font-family">Font</label>
              <Select
                id="font-family"
                options={fontOptions}
                disabled={this.props.disabled}
                value={this.props.fontFamily}
                onChange={this.handleSelectChange}
              />
            </div>
            <div className="six wide field">
              <label htmlFor="font-size">Font size</label>
              <input id="font-size" type="number" value={this.props.fontSize} min="1" onChange={this.handleInputChange} />
            </div>
          </div>
          <div className="fields">
            <div className="four wide field">
              <label htmlFor="font-color">Text color</label>
              <input id="font-color" type="color" value={this.props.fontColor} onChange={this.handleInputChange} />
            </div>
            <div className="four wide field">
              <label htmlFor="background-color">Background color</label>
              <input id="background-color" type="color" value={this.props.backgroundColor} onChange={this.handleInputChange} />
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
          <Button disabled={this.props.disabled} type="button">
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
  activeSelector: PropTypes.string,
  disabled: PropTypes.bool.isRequired,
  fontFamily: PropTypes.string.isRequired,
  fontSize: PropTypes.string.isRequired,
  fontColor: PropTypes.string.isRequired,
  backgroundColor: PropTypes.string.isRequired,
  setStyle: PropTypes.func.isRequired
};

StylerForm.defaultProps = {
  activeSelector: null
};
