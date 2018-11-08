import { connect } from 'react-redux';
import VariableSelector from '../components/VariableSelector';
import { getVariables } from '../store';
import { selectToken } from '../actions';

const mapStateToProps = $$state => (
  {
    variables: getVariables($$state)
  }
);

const mapDispatchToProps = dispatch => (
  { selectToken: value => dispatch(selectToken('variable', value)) }
);

export default connect(mapStateToProps, mapDispatchToProps)(VariableSelector);
