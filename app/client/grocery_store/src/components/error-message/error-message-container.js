import { connect } from 'react-redux';
import ErrorMessage from './error-message';

const mapStateToProps = state => (
  {
    visible: state.errorMessage.visible,
    message: state.errorMessage.message
  }
);

export default connect(mapStateToProps)(ErrorMessage);
