import { connect } from 'react-redux';
import AddToCart from './add-to-cart';
import { cartActionCreators } from '../../reducers/cart/cart-actions';

const mapStateToProps = state => (
  {
  }
);

const mapDispatchToProps = dispatch => (
  {
    handleAddToCart: (product, quantity) => {
      dispatch(cartActionCreators.addToCart(product, quantity));
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(AddToCart);
