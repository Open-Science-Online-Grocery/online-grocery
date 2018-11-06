import { connect } from 'react-redux';
import TestResults from '../components/TestResults';
import { getValid, getValidationMessage } from '../store';

const mapStateToProps = $$state => (
  {
    valid: getValid($$state),
    validationMessage: getValidationMessage($$state)
  }
);

export default connect(mapStateToProps)(TestResults);
