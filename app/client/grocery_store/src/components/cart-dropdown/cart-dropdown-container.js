import { connect } from 'react-redux';
import CartDropdown from './cart-dropdown';
import { cartActionCreators } from '../../reducers/cart/cart-actions';

const mapStateToProps = state => (
  {
    cart: state.cart
  }
);

const mapDispatchToProps = dispatch => (
  {
    handleRemoveFromCart: (product) => {
      dispatch(cartActionCreators.removeFromCart(product));
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(CartDropdown);
