import { connect } from 'react-redux';
import Subtab from './subtab';
import { categoryActionCreators } from '../../reducers/category/category-actions';

const mapStateToProps = (state, ownProps) => (
  {
    subsubcats: state.category.subsubcategories.filter(subsubcat => (
      subsubcat.subcategoryId === ownProps.subcat.id
    ))
  }
);

const mapDispatchToProps = dispatch => (
  {
    handleSetCategory: (category, subcategory, categoryType) => {
      dispatch(categoryActionCreators.updateCategory(category, subcategory, categoryType));
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(Subtab);
