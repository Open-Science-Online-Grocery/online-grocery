import { connect } from 'react-redux';
import WarningMessage from '../components/WarningMessage';
// import { getValid, getValidationMessage } from '../store';

const mapStateToProps = $$state => (
  {
    incompleteDataVariables: ['foo', 'bar']
  }
);

export default connect(mapStateToProps)(WarningMessage);
