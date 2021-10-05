import { connect } from 'react-redux';
import TopNav from './top-nav';

const mapStateToProps = (state) => {
  const {
    selectedCategoryId,
    selectedCategoryType,
    categories,
    subcategories,
    subtags
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

export default connect(mapStateToProps)(TopNav);
