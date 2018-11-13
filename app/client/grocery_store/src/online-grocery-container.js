import { connect } from 'react-redux';
import OnlineGrocery from './online-grocery';
import { categoryActionCreators } from './reducers/category/category-actions';

const mapStateToProps = state => (
  {
    category: state.category.category,
    categories: state.category.categories,
    subcategories: state.category.subcategories
  }
);

const mapDispatchToProps = dispatch => (
  {
    handleSetCategory: (category, subcategory) => {
      dispatch(categoryActionCreators.updateCategory(category, subcategory));
    },
    handleSetProducts: (products) => {
      dispatch(categoryActionCreators.setProducts(products));
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(OnlineGrocery);
