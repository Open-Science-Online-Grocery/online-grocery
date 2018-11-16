import { connect } from 'react-redux';
import ProductCardExpanded from './product-card-expanded';
import { cartActionCreators } from '../../reducers/cart/cart-actions';

const mapDispatchToProps = dispatch => (
  {
    handleAddToCart: (product, quantity) => {
      dispatch(cartActionCreators.addToCart(product, quantity));
    }
  }
);

const mapStateToProps = state => (
  {
    sessionId: state.user.sessionId,
    conditionIdentifier: state.user.conditionIdentifier
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(ProductCardExpanded);
