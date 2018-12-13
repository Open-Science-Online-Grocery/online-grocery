import { connect } from 'react-redux';
import AddToCart from './add-to-cart';
import { cartActionCreators } from '../../reducers/cart/cart-actions';
import { userActionCreators } from '../../reducers/user/user-actions';

const mapStateToProps = state => (
  {
  }
);

const mapDispatchToProps = dispatch => (
  {
    handleAddToCart: (product, quantity) => {
      dispatch(cartActionCreators.addToCart(product, quantity));
    },
    logParticipantAction: (actionType, productId, quantity) => {
      dispatch(
        userActionCreators.logParticipantAction(actionType, productId, quantity)
      );
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(AddToCart);
