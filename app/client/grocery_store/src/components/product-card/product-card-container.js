import { connect } from 'react-redux';
import ProductCard from './product-card';
import { cartActionCreators } from '../../reducers/cart/cart-actions';

const mapStateToProps = state => (
  {
    sessionId: state.user.sessionId,
    conditionIdentifier: state.user.conditionIdentifier
  }
);

const mapDispatchToProps = dispatch => (
  {
    handleAddToCart: (product, quantity) => {
      dispatch(cartActionCreators.addToCart(product, quantity));
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(ProductCard);
