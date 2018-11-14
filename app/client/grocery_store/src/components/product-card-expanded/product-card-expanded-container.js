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

const mapStateToProps = (state, ownProps) => {
  let css = null;
  if (ownProps.nutritionStyleRules) {
    css = new CssWriter(JSON.parse(ownProps.nutritionStyleRules)).cssString();
  }
  return {
    sessionId: state.user.sessionId,
    conditionIdentifier: state.user.conditionIdentifier,
    nutritionLabelCss: css
  };
};

export default connect(mapStateToProps, mapDispatchToProps)(ProductCardExpanded);
