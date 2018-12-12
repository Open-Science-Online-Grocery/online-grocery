import { connect } from 'react-redux';
import Subtab from './subtab';
import { categoryActionCreators } from '../../reducers/category/category-actions';

const mapStateToProps = () => (
  { }
);

const mapDispatchToProps = dispatch => (
  {
    handleSetCategory: (category, subcategory, categoryType) => {
      dispatch(categoryActionCreators.updateCategory(category, subcategory, categoryType));
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(Subtab);
