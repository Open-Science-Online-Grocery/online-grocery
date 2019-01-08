import { connect } from 'react-redux';
import WarningMessage from '../components/WarningMessage';
import { getIncompleteDataVariables } from '../store';

const mapStateToProps = $$state => (
  {
    incompleteDataVariables: getIncompleteDataVariables($$state)
  }
);

export default connect(mapStateToProps)(WarningMessage);
