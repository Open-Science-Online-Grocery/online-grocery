import { connect } from 'react-redux';
import ProductCardExpanded from './product-card-expanded';
import { cartActionCreators } from '../../reducers/cart/cart-actions';
import { userActionCreators } from '../../reducers/user/user-actions';
import CssWriter from '../../../../nutrition_styler/src/utils/CssWriter';

const mapStateToProps = (state, ownProps) => {
  let css = null;
  if (ownProps.nutritionStyleRules) {
    css = new CssWriter(JSON.parse(ownProps.nutritionStyleRules)).cssString();
  }
  return {
    nutritionLabelCss: css
  };
};

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

export default connect(mapStateToProps, mapDispatchToProps)(ProductCardExpanded);
