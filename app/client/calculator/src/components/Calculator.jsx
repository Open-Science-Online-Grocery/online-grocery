import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import VariableSelectorContainer from '../containers/VariableSelectorContainer';
import EquationEditorContainer from '../containers/EquationEditorContainer';

export default class Calculator extends PureComponent {
  render() {
    return (
      <div className="calculator">
        <div>
          <strong>Show this label on all products where:</strong>
        </div>
        <EquationEditorContainer />
        <VariableSelectorContainer />

        <div className="ui buttons operators">
          <button type="button" className="ui button">+</button>
          <button type="button" className="ui button">-</button>
          <button type="button" className="ui button">*</button>
          <button type="button" className="ui button">/</button>
          <button type="button" className="ui button">%</button>
          <button type="button" className="ui button">^</button>
          <button type="button" className="ui button">|</button>
          <button type="button" className="ui button">&</button>
        </div>
        <div className="ui buttons operators">
          <button type="button" className="ui button">{'<'}</button>
          <button type="button" className="ui button">{'>'}</button>
          <button type="button" className="ui button">{'<='}</button>
          <button type="button" className="ui button">{'>='}</button>
          <button type="button" className="ui button">!=</button>
          <button type="button" className="ui button">=</button>
          <button type="button" className="ui button">(</button>
          <button type="button" className="ui button">)</button>
        </div>
        <div className="ui buttons operators">
          <button type="button" className="ui button">IF</button>
          <button type="button" className="ui button">AND</button>
          <button type="button" className="ui button">OR</button>
          <button type="button" className="ui button">NOT</button>
          <button type="button" className="ui button">MIN</button>
          <button type="button" className="ui button">MAX</button>
          <button type="button" className="ui button">SUM</button>
          <button type="button" className="ui button">AVG</button>
        </div>
        <div className="ui buttons digits">
          <button type="button" className="ui button">0</button>
          <button type="button" className="ui button">1</button>
          <button type="button" className="ui button">2</button>
          <button type="button" className="ui button">3</button>
          <button type="button" className="ui button">4</button>
          <button type="button" className="ui button">5</button>
          <button type="button" className="ui button">6</button>
          <button type="button" className="ui button">7</button>
          <button type="button" className="ui button">8</button>
          <button type="button" className="ui button">9</button>
          <button type="button" className="ui button">.</button>
        </div>
        <div className="test-button">
          <button type="button" className="ui primary button">
            <i className="calculator icon" />
            Test calculation
          </button>
        </div>
      </div>
    );
  }
}
