import { connect } from 'react-redux';
import ProductCardExpanded from './product-card-expanded';
import { userActionCreators } from '../../reducers/user/user-actions';

const mapDispatchToProps = dispatch => (
  {
    logParticipantAction: (actionType, attributes) => {
      dispatch(
        userActionCreators.logParticipantAction(actionType, attributes)
      );
    }
  }
);

export default connect(null, mapDispatchToProps)(ProductCardExpanded);
