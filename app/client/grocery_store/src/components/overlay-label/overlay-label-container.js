import { connect } from 'react-redux';
import { userActionCreators } from '../../reducers/user/user-actions';
import OverlayLabel from './overlay-label';

const mapDispatchToProps = (dispatch, ownProps) => (
  {
    handleHoverAction: () => dispatch(
      userActionCreators.logParticipantAction(
        {
          type: `hover on ${ownProps.labelName} label`,
          productId: ownProps.productId,
          serialPosition: ownProps.productSerialPosition
        }
      )
    )
  }
);

export default connect(null, mapDispatchToProps)(OverlayLabel);
