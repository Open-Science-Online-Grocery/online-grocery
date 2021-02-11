import { connect } from 'react-redux';
import ProductCardExpanded from './product-card-expanded';
import { userActionCreators } from '../../reducers/user/user-actions';

const mapDispatchToProps = dispatch => (
  {
    logParticipantAction: (actionType, productId, quantity) => {
      dispatch(
        userActionCreators.logParticipantAction(actionType, productId, quantity)
      );
    }
  }
);

export default connect(null, mapDispatchToProps)(ProductCardExpanded);
