import { connect } from 'react-redux';
import ProductCardExpanded from './product-card-expanded';
import { userActionCreators } from '../../reducers/user/user-actions';

const mapDispatchToProps = dispatch => (
  {
    logParticipantAction: (attributes) => {
      dispatch(
        userActionCreators.logParticipantAction(attributes)
      );
    }
  }
);

export default connect(null, mapDispatchToProps)(ProductCardExpanded);
