import { connect } from 'react-redux';
import TopNav from './top-nav';
import { categoryActionCreators } from '../../reducers/category/category-actions';

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
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(TopNav);
