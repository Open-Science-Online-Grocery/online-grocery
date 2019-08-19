import { connect } from 'react-redux';
import VariableSelector from '../components/VariableSelector';
import { getVariables } from '../store';
import { selectToken, deletePreviousToken } from '../actions';

const mapStateToProps = ($$state) => (
  {
    variables: getVariables($$state)
  }
);

const mapDispatchToProps = (dispatch) => (
  {
    selectToken: (value) => dispatch(selectToken('variable', value)),
    deletePreviousToken: () => dispatch(deletePreviousToken())
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(VariableSelector);
