import { connect } from 'react-redux';
import { userActionCreators } from '../../reducers/user/user-actions';
import GuidingStars from './guiding-stars';

const mapDispatchToProps = dispatch => (
  {
    handleHoverAction: (product) => dispatch(
      userActionCreators.logParticipantAction(
        {
          type: 'hovered',
          productId: product.id,
          serialPosition: product.serialPosition
        }
      )
    )
  }
);

export default connect(null, mapDispatchToProps)(GuidingStars);
