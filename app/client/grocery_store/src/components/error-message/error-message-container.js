import { connect } from 'react-redux';
import ErrorMessage from './error-message';

const mapStateToProps = state => (
  {
    visible: true,
    message: 'this is a test'
  }
);

export default connect(mapStateToProps)(ErrorMessage);
