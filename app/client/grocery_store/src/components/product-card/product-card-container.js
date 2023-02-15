import { connect } from 'react-redux';
import ProductCard from './product-card';

const mapStateToProps = state => (
  {
    showAddToCartButton: !state.user.onlyAddToCartFromDetailPage,
    showGuidingStars: state.user.showGuidingStars,
    displayOldPrice: state.user.displayOldPrice
  }
);

export default connect(mapStateToProps)(ProductCard);
