import { connect } from 'react-redux';
import EquationEditor from '../components/EquationEditor';
import { getTokensWithName, getCursorPosition } from '../store';

const mapStateToProps = $$state => (
  {
    tokens: getTokensWithName($$state),
    cursorPosition: getCursorPosition($$state)
  }
);

export default connect(mapStateToProps)(EquationEditor);
