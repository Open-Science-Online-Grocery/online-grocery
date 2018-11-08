import React from 'react';
import { connect } from 'react-redux';
import './online-grocery.scss';
import SessionIDPage from './session-id-page';
import { userActionCreators } from './reducers/user/user-actions';

const mapDispatchToProps = dispatch => (
  {
    handleSetUser: (sessionID) => {
      dispatch(userActionCreators.setUser(sessionID));
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
