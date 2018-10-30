import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import { Button, Icon } from 'semantic-ui-react';

export default class StylerForm extends PureComponent {
  disabledClass() {
    return this.props.activeSelector ? '' : 'disabled';
  }

  render() {
    return (
      <React.Fragment>
        <p className={this.props.activeSelector ? 'disabled' : ''}>To change nutrition label styling, click part of the label to the left.</p>
        <div className={`ui segment ${this.disabledClass()}`}>
          <div className="fields">
            <div className="ten wide field">
              <label htmlFor="font-family">Font</label>
              <select id="font-family" className="ui dropdown">
                <option>Arial</option>
                <option>Helvetica</option>
                <option>Times New Roman</option>
                <option>Courier</option>
                <option>Veranda</option>
                <option>Georgia</option>
                <option>Palatino</option>
                <option>Garamond</option>
                <option>Comic Sans MS</option>
                <option>Trebuchet MS</option>
                <option>Arial Black</option>
                <option>Impact</option>
              </select>
            </div>
            <div className="six wide field">
              <label htmlFor="font-size">Font size</label>
              <input id="font-size" type="number" value="8" min="1" />
            </div>
          </div>
          <div className="fields">
            <div className="four wide field">
              <label htmlFor="font-color">Text color</label>
              <input id="font-color" type="color" value="#000000" />
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
        <div>
          <Button disabled={!this.props.activeSelector} type="button">
            <Icon name="undo" />
            Reset
          </Button>
          <Button disabled={!this.props.activeSelector} primary floated="right" type="button">
            <Icon name="check" />
            Apply
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
