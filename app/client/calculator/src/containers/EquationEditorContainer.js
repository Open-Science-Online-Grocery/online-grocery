import { connect } from 'react-redux';
import EquationEditor from '../components/EquationEditor';
import { getTokensWithName, getCursorPosition, getCalculatorFocus } from '../store';
import { arrowKeyPressed, deletePreviousToken } from '../actions';

const mapStateToProps = $$state => (
  {
    tokens: getTokensWithName($$state),
    cursorPosition: getCursorPosition($$state),
    calculatorFocus: getCalculatorFocus($$state)
  }
);

const mapDispatchToProps = dispatch => (
  {
    arrowKeyPressed: shouldMoveForwards => dispatch(
      arrowKeyPressed(shouldMoveForwards)
    ),
    deletePreviousToken: () => dispatch(deletePreviousToken())
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(EquationEditor);
