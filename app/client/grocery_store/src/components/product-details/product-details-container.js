import { connect } from 'react-redux';
import ProductDetails from './product-details';
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

export default connect(mapStateToProps)(ProductDetails);
