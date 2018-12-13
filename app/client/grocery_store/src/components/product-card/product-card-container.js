import { connect } from 'react-redux';
import ProductCard from './product-card';

const mapStateToProps = state => (
  {
    showAddToCartButton: !state.user.onlyAddToCartFromDetailPage
  }
);

export default connect(mapStateToProps)(ProductCard);
