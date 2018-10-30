import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';

export default class StylerForm extends PureComponent {
  render() {
    return (
      <React.Fragment>
        <p>To change nutrition label styling, click part of the label to the left </p>
        <div className="ui disabled segment">
          <div className="fields">
            <div className="ten wide field">
              <label>Font</label>
              <select className="ui dropdown">
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
              <label>Font size</label>
              <input type="number" value="8" min="1" />
            </div>
          </div>
          <div className="fields">
            <div className="four wide field">
              <label>Text color</label>
              <input type="color" value="#000000" />
            </div>
            <div className="four wide field">
              <label>Background color</label>
              <input type="color" value="#ffffff" />
            </div>
            <div className="eight wide field">
              <label>Text style</label>
              <div className="ui icon buttons">
                <button type="button" className="ui button"><i className="bold icon" /></button>
                <button type="button" className="ui button"><i className="italic icon" /></button>
                <button type="button" className="ui button active"><i className="strikethrough icon" /></button>
                <button type="button" className="ui button"><i className="underline icon" /></button>
              </div>
            </div>
          </div>
        </div>
      </React.Fragment>
    );
  }
}

