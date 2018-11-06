import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import VariableSelectorContainer from '../containers/VariableSelectorContainer';
import EquationEditorContainer from '../containers/EquationEditorContainer';
import OperatorButtonRowContainer from '../containers/OperatorButtonRowContainer';
import DigitButtonRowContainer from '../containers/DigitButtonRowContainer';

const operators1 = ['+', '-', '*', '/', '%', '^', '|', '&'];
const operators2 = ['<', '>', '<=', '>=', '!=', '=', '(', ')'];
const operators3 = ['IF', 'AND', 'OR', 'NOT', 'MIN', 'MAX', 'SUM', 'AVG'];
const digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'];

export default class Calculator extends PureComponent {
  render() {
    return (
      <div className="calculator">
        <div>
          <strong>Show this label on all products where:</strong>
        </div>
        <EquationEditorContainer />
        <VariableSelectorContainer />
        <OperatorButtonRowContainer values={operators1} className="operators" />
        <OperatorButtonRowContainer values={operators2} className="operators" />
        <OperatorButtonRowContainer values={operators3} className="operators" />
        <DigitButtonRowContainer values={digits} className="digits" />
        <div className="test-button">
          <button type="button" className="ui primary button">
            <i className="calculator icon" />
            Test calculation
          </button>
        </div>
        <input type="hidden" name={this.props.inputName} value={this.props.tokensJson} />
      </div>
    );
  }
}

Calculator.propTypes = {
  inputName: PropTypes.string.isRequired,
  tokensJson: PropTypes.string.isRequired
};
