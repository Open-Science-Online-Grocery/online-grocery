import { connect } from 'react-redux';
import ProductCardExpanded from './product-card-expanded';
import { userActionCreators } from '../../reducers/user/user-actions';
import CssWriter from '../../../../nutrition_styler/src/utils/CssWriter';

const mapStateToProps = (state, ownProps) => {
  let css = null;
  if (ownProps.nutritionStyleRules) {
    css = new CssWriter(JSON.parse(ownProps.nutritionStyleRules)).cssString();
  }
  return {
    nutritionLabelCss: css,
    showGuidingStars: state.user.showGuidingStars
  };
};

const mapDispatchToProps = dispatch => (
  {
    logParticipantAction: (actionType, productId, quantity) => {
      dispatch(
        userActionCreators.logParticipantAction(actionType, productId, quantity)
      );
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(ProductCardExpanded);
