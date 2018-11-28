import { connect } from 'react-redux';
import OrderSummary from './order-summary';
import { cartActionCreators } from '../../../reducers/cart/cart-actions';

const mapStateToProps = state => (
  {
    cart: state.cart,
    sessionId: state.user.sessionId,
    conditionIdentifier: state.user.conditionIdentifier
  }
);

const mapDispatchToProps = dispatch => (
  {
    handleRemoveFromCart: (product) => {
      dispatch(cartActionCreators.removeFromCart(product));
    },
    handleClearCart: () => {
      dispatch(cartActionCreators.clearCart());
    },
    getCartSettings: () => {
      dispatch(cartActionCreators.getCartSettings());
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(OrderSummary);
