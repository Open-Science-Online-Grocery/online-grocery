import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import { Button, Icon } from 'semantic-ui-react';
import VariableSelectorContainer from '../containers/VariableSelectorContainer';
import EquationEditorContainer from '../containers/EquationEditorContainer';
import OperatorButtonRowContainer from '../containers/OperatorButtonRowContainer';
import DigitButtonRowContainer from '../containers/DigitButtonRowContainer';
import TestResultsContainer from '../containers/TestResultsContainer';
import WarningMessageContainer from '../containers/WarningMessageContainer';

const operators1 = ['+', '-', '*', '/', '%', '^', '|', '&'];
const operators2 = ['<', '>', '<=', '>=', '!=', '=', '(', ')'];
const operators3 = ['IF', 'AND', 'OR', 'NOT', 'MIN', 'MAX', 'SUM', 'AVG'];
const digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'];

export default class Calculator extends PureComponent {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }

  componentDidMount() {
    document.addEventListener('click', this.handleClick, false);
  }

  componentWillUnmount() {
    document.removeEventListener('click', this.handleClick, false);
  }

  handleClick(event) {
    this.props.setCalculatorFocus(this.node.contains(event.target));
  }

  render() {
    return (
      <div
        className="calculator"
        onClick={this.handleClick}
        role="presentation"
        ref={(node) => { this.node = node; }}
      >
        <TestResultsContainer />
        <WarningMessageContainer />
        <EquationEditorContainer />
        <VariableSelectorContainer />
        <OperatorButtonRowContainer values={operators1} className="operators" />
        <OperatorButtonRowContainer values={operators2} className="operators" />
        <OperatorButtonRowContainer values={operators3} className="operators" />
        <DigitButtonRowContainer values={digits} className="digits" />
        <div className="test-button">
          <Button
            type="button"
            className="primary"
            onClick={this.props.testCalculation}
            disabled={!this.props.testable}
          >
            <Icon name="calculator" />
            Test Calculation
          </Button>
        </div>
        <input type="hidden" name={this.props.inputName} value={this.props.tokensJson} />
      </div>
    );
  }
}

Calculator.propTypes = {
  inputName: PropTypes.string.isRequired,
  tokensJson: PropTypes.string.isRequired,
  testCalculation: PropTypes.func.isRequired,
  testable: PropTypes.bool.isRequired,
  setCalculatorFocus: PropTypes.func.isRequired
};
