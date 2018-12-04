import { connect } from 'react-redux';
import ProductCard from './product-card';
import { cartActionCreators } from '../../reducers/cart/cart-actions';
import { userActionCreators } from '../../reducers/user/user-actions';

const mapStateToProps = state => (
  {
    showAddToCartButton: !state.user.onlyAddToCartFromDetailPage
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

export default connect(mapStateToProps, mapDispatchToProps)(ProductCard);
