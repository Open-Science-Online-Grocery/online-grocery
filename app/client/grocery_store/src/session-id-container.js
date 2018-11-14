import { connect } from 'react-redux';
import SessionIDPage from './session-id-page';
import { userActionCreators } from './reducers/user/user-actions';

const mapDispatchToProps = dispatch => (
  {
    handleSessionIdSubmitted: (sessionId, conditionIdentifier) => {
      dispatch(userActionCreators.sessionIdSubmitted(
        sessionId, conditionIdentifier
      ));
    }
  }
);

export default connect(null, mapDispatchToProps)(SessionIDPage);
