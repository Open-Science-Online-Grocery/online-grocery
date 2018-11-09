import React from 'react';
import { connect } from 'react-redux';
import './online-grocery.scss';
import SessionIDPage from './session-id-page';
import { userActionCreators } from './reducers/user/user-actions';

const mapDispatchToProps = dispatch => (
  {
    handleSetUser: (sessionID, conditionIdentifier) => {
      dispatch(userActionCreators.setUser(sessionID, conditionIdentifier));
    }
  }
);


class SessionIDContainer extends React.Component{

  render() {
      return(
          <SessionIDPage {...this.props} />
      )
  }
}
export default connect(null, mapDispatchToProps)(SessionIDContainer)
