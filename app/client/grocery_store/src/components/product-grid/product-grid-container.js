import { connect } from 'react-redux';
import ProductGrid from './product-grid';

const mapStateToProps = state => (
  {
    products: state.category.products,
    searchType: state.search.type,
    loaderActive: state.category.loaderActive
  }
);

export default connect(mapStateToProps, null)(ProductGrid);
