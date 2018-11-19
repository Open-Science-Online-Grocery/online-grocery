import { connect } from 'react-redux';
import ProductGrid from './product-grid';

const mapStateToProps = state => (
  {
    sessionId: state.user.sessionId,
    products: state.category.products
  }
);

export default connect(mapStateToProps, null)(ProductGrid);
