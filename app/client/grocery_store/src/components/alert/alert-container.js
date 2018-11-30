import { connect } from 'react-redux';
import Alert from './alert';
import { alertActionCreators } from '../../reducers/alert/alert-actions';

const mapStateToProps = state => (
  {
    visible: state.alert.visible,
    message: state.alert.message
  }
);

const mapDispatchToProps = dispatch => (
  {
    handleDismiss: () => {
      dispatch(alertActionCreators.dismissAlert());
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(Alert);
