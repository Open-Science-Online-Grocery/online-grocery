import { connect } from 'react-redux';
import EquationEditor from '../components/EquationEditor';
import { getTokensWithName, getCursorPosition } from '../store';
import { arrowKeyPressed, deletePreviousToken } from '../actions';

const mapStateToProps = $$state => (
  {
    tokens: getTokensWithName($$state),
    cursorPosition: getCursorPosition($$state)
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
