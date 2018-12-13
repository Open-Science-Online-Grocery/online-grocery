import { connect } from 'react-redux';
import AddToCart from './add-to-cart';
import { cartActionCreators } from '../../reducers/cart/cart-actions';

const mapStateToProps = state => (
  {
    mayAddToCartByDollarAmount: state.user.mayAddToCartByDollarAmount
  }
);

const mapDispatchToProps = dispatch => (
  {
    handleAddToCart: (product, amount, addByDollar) => {
      dispatch(cartActionCreators.addToCart(product, amount, addByDollar));
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(AddToCart);
