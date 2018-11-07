import React from 'react'
import './online-grocery.scss'
import SessionIDPage from './session-id-page'
import { connect } from 'react-redux'
import { userActionCreators } from './reducers/user/user-actions';

const mapDispatchToProps = function (dispatch) {
    return {
        handleSetUser: (sessionID) => {
            dispatch(userActionCreators.setUser(sessionID))
        }
    }
}


class SessionIDContainer extends React.Component{

  render() {
      return(
          <SessionIDPage {...this.props} />
      )
  }
}
export default connect(null, mapDispatchToProps)(SessionIDContainer)
