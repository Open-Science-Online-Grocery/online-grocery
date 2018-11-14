import { connect } from 'react-redux';
import ProductCardExpanded from './product-card-expanded';
import { cartActionCreators } from '../../reducers/cart/cart-actions';
import CssWriter from '../../../../nutrition_styler/src/utils/CssWriter';

const mapDispatchToProps = dispatch => (
  {
    handleAddToCart: (product, quantity) => {
      dispatch(cartActionCreators.addToCart(product, quantity));
    }
  }
);

const mapStateToProps = (state, ownProps) => (
  {
    sessionId: state.user.sessionId,
    conditionIdentifier: state.user.conditionIdentifier,
    nutritionLabelCss: new CssWriter(JSON.parse(ownProps.nutritionStyleRules)).cssString()
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(ProductCardExpanded);
