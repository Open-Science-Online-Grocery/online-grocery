import { connect } from 'react-redux';
import EquationEditor from '../components/EquationEditor';
import { getTokensWithName, getCursorPosition } from '../store';
import { moveCursor } from '../actions';

const mapStateToProps = $$state => (
  {
    tokens: getTokensWithName($$state),
    cursorPosition: getCursorPosition($$state)
  }
);

const mapDispatchToProps = dispatch => (
  { moveCursor: forwards => dispatch(moveCursor(forwards)) }
);

export default connect(mapStateToProps, mapDispatchToProps)(EquationEditor);
