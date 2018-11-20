import { connect } from 'react-redux';
import TopNav from './top-nav';
import { categoryActionCreators } from '../../reducers/category/category-actions';

const mapStateToProps = (state) => {
  const {
    selectedCategoryId, selectedCategoryType, categories, subcategories, subtags
  } = state.category;
  const tags = state.category.tags;
  // TODO: Change this if they want to choose which tag gets displayed as a tab
  const firstTag = tags.length > 0 ? Object.values(tags)[0] : null;
  return ({
    selectedCategoryId,
    selectedCategoryType,
    displayedTag: firstTag,
    categories,
    subcategories,
    tags,
    subtags
  });
};

const mapDispatchToProps = dispatch => (
  {
    handleSetCategory: (category, subcategory, categoryType) => {
      dispatch(categoryActionCreators.updateCategory(category, subcategory, categoryType));
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(TopNav);
