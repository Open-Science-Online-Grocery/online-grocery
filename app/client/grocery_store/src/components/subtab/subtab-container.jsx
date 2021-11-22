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

const mapDispatchToProps = (dispatch, ownProps) => (
  {
    handleSetCategory: (subsubcategoryId) => {
      dispatch(
        categoryActionCreators.updateCategory(
          ownProps.categoryId,
          ownProps.subcat.id,
          subsubcategoryId,
          ownProps.categoryType
        )
      );
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(Subtab);
