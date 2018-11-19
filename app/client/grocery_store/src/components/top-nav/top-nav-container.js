import { connect } from 'react-redux';
import TopNav from './top-nav';
import { categoryActionCreators } from '../../reducers/category/category-actions';

const mapStateToProps = (state) => {
  const {
    category, categories, subcategories, /* tag, */ subtags
  } = state.category;
  const tags = state.category.tags;
  const tag = tags.length > 0 ? Object.values(tags)[0] : null; // TODO: Supply correct prop
  return ({
    category,
    tag,
    categories,
    subcategories,
    subtags
  });
};

const mapDispatchToProps = dispatch => (
  {
    handleSetCategory: (category, subcategory) => {
      dispatch(categoryActionCreators.updateCategory(category, subcategory));
    }
    // TODO:
    // handleSetTag: (category, subcategory) => {
    //   dispatch(categoryActionCreators.updateCategory(category, subcategory));
    // }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(TopNav);
