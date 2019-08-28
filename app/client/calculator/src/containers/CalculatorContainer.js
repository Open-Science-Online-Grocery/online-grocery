import { connect } from 'react-redux';
import Calculator from '../components/Calculator';
import { getInputName, getTokensJson, getTokenCount } from '../store';
import { testCalculation, setCalculatorFocus } from '../actions';

const mapStateToProps = ($$state) => (
  {
    inputName: getInputName($$state),
    tokensJson: getTokensJson($$state),
    testable: getTokenCount($$state) > 0
  }
);

const mapDispatchToProps = (dispatch) => (
  {
    testCalculation: () => dispatch(testCalculation()),
    setCalculatorFocus: (calculatorFocus) => dispatch(
      setCalculatorFocus(calculatorFocus)
    )
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(Calculator);
