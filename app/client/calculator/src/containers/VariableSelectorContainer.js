import { connect } from 'react-redux';
import VariableSelector from '../components/VariableSelector';
import { getVariables } from '../store';

const mapStateToProps = $$state => (
  {
    variables: getVariables($$state)
  }
);

export default connect(mapStateToProps)(VariableSelector);
